using module '.\FlowTree.psm1'

Function getDescriptionCoverage($flowFile){
    $blocksWithDescription = 0
    $blocksWithoutDescription = 0

    Function countBlocks($blocks){
        $description = 0
        $noDescription = 0
        $ignoredBlocks = getBlocksToExcludeFromDescriptionCoverage

        foreach ($block in $blocks) {
            #Do not process blocks to ignore
            if($ignoredBlocks -notcontains $block.blockType) {
                if ($block.properties.'main-properties.description' -eq "") {
                    $noDescription += 1
                }
                else {
                    $description += 1
                }
            }
        }
        return $description, $noDescription
    }

    if($flowFile.GetType().name -eq "CortexFlow"){
        foreach ($state in $flowFile.states) {
            $result = countBlocks -blocks $state.blocks
            $blocksWithDescription += $result[0]
            $blocksWithoutDescription += $result[1]
        }
    } else {
        $result = countBlocks -blocks $flowFile.blocks
        $blocksWithDescription += $result[0]
        $blocksWithoutDescription += $result[1]
    }

    if(($blocksWithDescription + $blocksWithoutDescription) -eq 0) {
        return 100
    }
    else {
        return [math]::Round((100*$blocksWithDescription)/($blocksWithDescription + $blocksWithoutDescription), 1)
    }
}

Function countBlockType([String] $blockType, $flowFile){

    $matchingBlocks = 0
    Function countBlocks($blocks, $type){
        $matches = 0
        foreach ($block in $blocks) {
            if($block.blockType -eq $type){
                $matches++
            }
        }
        return $matches
    }

    if($flowFile.GetType().name -eq "CortexFlow"){
        foreach ($state in $flowFile.states) {
            $matchingBlocks += countBlocks -blocks $state.blocks -type $blockType
        }
    } else {
        $matchingBlocks += countBlocks -blocks $flowFile.blocks -type $blockType
    }

    return $matchingBlocks
}

Function checkConnections($flowFile){

    Function checkBlocks($blocks, $name){
        $ignore = @("SEQ_FB_FREETEXT")
        $onlySource = @("SEQ_FB_EXIT_POINT", "SEQ_FB_END_POINT", "SEQ_FB_WIRELESS_SENDER", "SEQ_FB_SIGNAL_ERROR")
        $onlyTarget = @("SEQ_FB_ENTRY_POINT", "SEQ_FB_WIRELESS_RECEIVER", "SEQ_FB_ERROR_HANDLER_BLOCK")
        $multiTarget = @("SEQ_FB_PATTERN_DECISION", "SEQ_FB_PATTERN_DECISION_2", "SEQ_FB_CHECK_PARAMETER_EXISTENCE", "SEQ_FB_CHECK_PARAMETER_EXISTENCE_2", "SEQ_FB_EXPRESSION_DECISION", "SEQ_FB_EXPRESSION_DECISION_2", "SEQ_FB_FOR_LOOP", "SEQ_FB_FOREACH_LOOP")
        $missingConnections = @()

        foreach ($block in $blocks) {
            $block.location = $name
            
            if(-not ($block.blocktype -in $ignore)){
                if($block.blockType -in $onlySource){
                    if($block.sourceBlocks.Count -lt 1){
                        $missingConnections += $block   
                    }
                } elseif ($block.blockType -in $onlyTarget) {
                    if($block.targetBlocks.Count -lt 1){
                        $missingConnections += $block   
                    }
                } elseif ($block.blockType -in $multiTarget) {
                    if($block.sourceBlocks.Count -lt 1 -or $block.targetBlocks.Count -lt 2){
                        $missingConnections += $block   
                    }            
                } else {
                    if($block.sourceBlocks.Count -lt 1 -or $block.targetBlocks.Count -lt 1){
                        $missingConnections += $block   
                    }
                }            
            }
        }
        return $missingConnections    
    }

    $missingConnectionBlocks = @()

    if($flowFile.GetType().name -eq "CortexFlow"){
        foreach ($state in $flowFile.states) {
            $missingConnectionBlocks += checkBlocks -blocks $state.blocks -name $state.stateName
        }
    } else {
        $missingConnectionBlocks += checkBlocks -blocks $flowFile.blocks -name $flowFile.subtaskName
    }

    return $missingConnectionBlocks
}

Function findVariablesInBlock($variables,$block){

    $stateVariables = [System.Collections.ArrayList]$variables

    foreach($variable in $variables) {
        #If variable exists
        $varNameTrim = $variable.varName.Trim('($)')

        if ((getVariableFormats($varNameTrim) | %{(convertto-json $block.properties).ToLower().contains($_.ToLower())}) -contains $true) {
            $stateVariables.Remove($variable)   
        }
        elseif($specialBlocks.blockType.IndexOf($block.blockType) -ge 0){
        #special block
            foreach($specialProperty in $specialBlocks.GetValue($specialBlocks.blockType.IndexOf($block.blockType)).properties){
                $propertyKey = ($block.properties.keys -like '*'+$specialProperty)
                if (($varNameTrim | %{(convertto-Json ($block.properties.GetEnumerator() | ? Key -eq $propertyKey | % Value)).contains($_)}) -contains $true) {
                    $stateVariables.Remove($variable)
                }
            }
        }
    }

    return $stateVariables
}

Function checkUnusedVariables($flowFile){
    $unusedVariables = @()

    $specialBlocks = getPropertiesToInclude

    if (!$flow.flowName) {
        #Subtask
        #Check Subtask unsused variables
        foreach($block in $flow.blocks) { 
            $flow.variables = findVariablesInBlock -variables $flow.variables -block $block
        }

        #Variables left in the array are not used
        foreach($variable in $state.variables) {
                $variable.location = 'Subtask Variable Store'
                $variable.varName = $variable.varName.Trim('($)')
                $unusedVariables += $variable
        }
    }
    else {
        #Flow
        #Check each state variables
        foreach ($state in $flow.states){
            #For each block check if variables are in use
            foreach($block in $state.blocks) { 
                $state.variables = findVariablesInBlock -variables $state.variables -block $block
                $flow.globalVariables = findVariablesInBlock -variables $flow.globalVariables -block $block
            }

            #Variables left in the array are not used
            foreach($variable in $state.variables) {
                    $variable.location = 'State "'+$state.stateName.Trim('($)')+'" variable store'
                    $variable.varName = $variable.varName.Trim('($)')
                    $unusedVariables += $variable
            }
        }

        #Variables left in the array are not used
        foreach($variable in $flow.globalVariables) {
                $variable.location = 'Flow Variable Store'
                $variable.varName = $variable.varName.Trim('($)')
                $unusedVariables += $variable
        }

    }

    return ,$unusedVariables
}

