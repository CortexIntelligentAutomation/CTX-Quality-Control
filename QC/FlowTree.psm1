<#
.SYNOPSIS
Class representing a Cortex Flow

.PARAMETER flowName
The name of the flow

.PARAMETER flowId
The ID of the flow

.PARAMETER globalVariables
The glabal variables accross the flow, hashtable of the form:
{
    "InitialValue": <any>,
    "setInitialValue": <boolean>,
    "varName": "<string>",
    "varType": "<string>"
}

.PARAMETER defaulErrorHandler
Cortex State representing the flow's Deafault Error Handler

.PARAMETER states
List of Cortex States that the flow contains
#>
class CortexFlow {
    [string] $flowName
    [string] $flowID
    [hashtable[]] $globalVariables
    [CortexState] $defaulErrorHandler
    [CortexState[]] $states

    CortexFlow(){}

    CortexFlow(
        [string] $flowName,
        [string] $flowID,
        [hashtable[]] $globalVariables,
        [CortexState] $defaulErrorHandler,
        [CortexState[]] $states
    ){
        $this.flowName = $flowName
        $this.flowID = $flowID
        $this.globalVariables = $globalVariables
        $this.defaulErrorHandler = $defaulErrorHandler
        $this.states = $states
    }

    [void] addState([CortexState] $newState) {
        $this.states += $newState
    }

    [void] updateDefaultErrorHandler([CortexState] $errorHandler) {
        $this.defaulErrorHandler = $errorHandler
    }

    [void] updateGlobalVarStore([Hashtable[]] $vars) {
        $this.globalVariables = $vars
    }
}

<#
.SYNOPSIS
Class representing a Cortex Subtasl

.PARAMETER subtaskName
The name of the subtask

.PARAMETER subtaskId
The ID of the subtask

.PARAMETER blocks
List of Cortex blocks that the flow contains

.PARAMETER variables
The variables of the state, hashtable of the form:
{
    "InitialValue": <any>,
    "setInitialValue": <boolean>,
    "varName": "<string>",
    "varType": "<string>"
}
#>
class CortexSubtask {
    [string] $subtaskName
    [string] $subtaskID
    [CortexBlock[]] $blocks
    [hashtable[]] $variables

    CortexSubtask(){}

    CortexSubtask(
        [string] $subtaskName,
        [string] $subtaskID,
        [CortexBlock[]] $blocks,
        [hashtable[]] $variables
    ){
        $this.flowName = $subtaskName
        $this.flowID = $subtaskID
        $this.blocks = $blocks
        $this.variables = $variables
    }

        [void] addBlock([CortexBlock] $newBlock) {
        $this.blocks += $newBlock
    }

    [void] updateVarStore([Hashtable[]] $vars) {
        $this.variables = $vars
    }

    [CortexBlock] getBlockById([string] $id) {
        foreach ($block in $this.blocks) {
            if ($block.blockId -eq $id) {
                Return [CortexBlock]::new(
                    $block.blockType,
                    $block.blockId,
                    $block.properties,
                    $block.sourceBlocks,
                    $block.targetBlocks,
                    $block.localExceptionHandler
                )
            }
        }
        Return [CortexBlock]::new()
    }

    [void] replaceBlockbyId([string] $id, [cortexBlock] $newBlock) {
        foreach ($block in $this.blocks) {
            if ($block.blockId -eq $id) {
                $this.blocks.Item([array]::IndexOf($this.blocks, $block)) = $newBlock
            }
        }
    }

}

<#
.SYNOPSIS
Class representing a Cortex State

.PARAMETER stateName
The name of the state

.PARAMETER stateName
The ID of the state
    
.PARAMETER blocks
List of Cortex blocks that the flow contains

.PARAMETER variables
The variables of the state, hashtable of the form:
{
    "InitialValue": <any>,
    "setInitialValue": <boolean>,
    "varName": "<string>",
    "varType": "<string>"
}
#>
class CortexState {    
    [string] $stateName
    [string] $stateID
    [CortexBlock[]] $blocks
    [hashtable[]] $variables

    CortexState(){}
    
    CortexState(
        [string] $stateName,
        [string] $stateID,
        [CortexBlock[]] $blocks,
        [hashtable[]] $variables
    ){
        $this.stateName = $stateName
        $this.stateID = $stateID
        $this.blocks = $blocks 
        $this.variables = $variables 
    }

    [void] addBlock([CortexBlock] $newBlock) {
        $this.blocks += $newBlock
    }

    [void] updateVarStore([Hashtable[]] $vars) {
        $this.variables = $vars
    }

    [CortexBlock] getBlockById([string] $id) {
        foreach ($blockInState in $this.blocks) {
            if ($blockInState.blockId -eq $id) {
                Return [CortexBlock]::new(
                    $blockInState.blockType,
                    $blockInState.blockId,
                    $blockInState.properties,
                    $blockInState.sourceBlocks,
                    $blockInState.targetBlocks,
                    $blockInState.localExceptionHandler
                )
            }
        }
        Return [CortexBlock]::new()
    }

    [void] replaceBlockbyId([string] $id, [cortexBlock] $newBlock) {
        foreach ($block in $this.blocks) {
            if ($block.blockId -eq $id) {
                $this.blocks.Item([array]::IndexOf($this.blocks, $block)) = $newBlock
            }
        }
    }
}

<#
.SYNOPSIS
Class representing a Cortex Block

.PARAMETER blockType
The name of block

.PARAMETER blockID
The ID of the block
    
.PARAMETER properties
Hashtable containing the names and values of the block's properties

.PARAMETER sourceBlocks
The blocks preceding this one

.PARAMETER targetBlocks
The blocks succeeding this one
#>
class CortexBlock {
    [string] $blockType
    [string] $blockID
    [hashtable] $properties
    [string[]] $sourceBlocks
    [string[]] $targetBlocks
    [string] $localExceptionHandler
    [string] $location

    CortexBlock(){}

    CortexBlock(
        [string] $blockType,
        [string] $blockID,
        [hashtable] $properties,
        [string[]] $sourceBlocks,
        [string[]] $targetBlocks,
        [string] $localExceptionHandler
    ){
        $this.blockType = $blockType
        $this.blockID = $blockId
        $this.properties = $properties
        $this.sourceBlocks = $sourceBlocks
        $this.targetBlocks = $targetBlocks
        $this.localExceptionHandler = $localExceptionHandler
    }

    [void] addSource([string] $newSource) {
        $this.sourceBlocks += $newSource
    }

    [void] addTarget([string] $newTarget) {
        $this.targetBlocks += $newTarget
    }

    [void] addExceptionHandler([string] $exceptionHandlerID) {
        $this.localExceptionHandler = $exceptionHandlerID
    }
}

<#
.SYNOPSIS
Returns the properties of a block

.PARAMETER workspaceId
The ID of the workspace to be queried.
#>
function GetBlockProperties {

    param(
        [PSObject] $block,
        [String] $UIElementName = $null
    )

    #add properties
    $propetiesTable = @{}
    foreach ($propertyGroup in $block.properties.PSObject.Properties){
        foreach ($property in $propertyGroup.PSObject.Properties) {
            #Only process properties that can be used in Gateway
            if($property.Name -eq 'Value') {
                foreach($GatewayProperty in $property.Value.PSObject.Properties) {
                    if($UIElementName){
                        $propertyName = $UIElementName+'.'+$propertyGroup.Name+'.'+$GatewayProperty.Name
                    }
                    else {
                        $propertyName = $propertyGroup.Name+'.'+$GatewayProperty.Name
                    }
                    $propetiesTable.Add($propertyName, $GatewayProperty.value.value)
                }
            }
        }
    }

    return $propetiesTable

}
<#
.SYNOPSIS
Returns the type of workspace based on its ID

.PARAMETER workspaceId
The ID of the workspace to be queried.

.PARAMETER flowPsObject
The contents flow file containing the workspace, converted to a PsCustomObject using the ConvertFrom-JSON cmdlet.

.PARAMETER parentWorkspaceId
The ID of the parent of the workspace to be queried, default is the top level workspace of the flow passed in
#>
function GetWorkspaceType {

    param(
        [string]$workspaceId,
        [psobject]$flowPsObject,
        [string]$parentWorkspaceId = $flowPsObject.Json.firstWorkSpace
    )

    foreach ($workspace in $flowPsObject.Json.$($parentWorkspaceId).items) {
        if ($workspace.userData.link -eq $workspaceId) {
            return $workspace.type
        }
    }
}

<#
.SYNOPSIS
Returns returns a list of variables from a workspace

.DESCRIPTION
Returns returns a list of variables based on the ID of the workspace containing them, given that this workspace is a variables store.

.PARAMETER workspaceId
The ID of the workspace to be queried.

.PARAMETER flowPsObject
The contents flow file containing the workspace, converted to a PsCustomObject using the ConvertFrom-JSON cmdlet

.PARAMETER parentWorkspaceId
The ID of the parent of the workspace to be queried, default is the top level workspace of the flow passed in
#>
function GetVariablesFromWorkspace {

    param(
        [string]$workspaceId,
        [psobject]$flowPsObject,
        [string]$parentWorkspaceId = $flowPsObject.Json.firstWorkSpace
    )

    if (GetWorkspaceType -flowPsObject $flowPsObject -workspaceId $workspaceId -parentWorkspaceId $parentWorkspaceId -eq "SEQ_VARIABLE_STORE") {
    
        $variables = @()

        foreach ($variable in $flowPsObject.Json.$($workspaceId).items) {
            if ($variable.type -match 'SEQ_VARIABLE') {        
                $variable = @{
                    varName=$variable.properties."main-properties"."variable-name".value; 
                    varType=$variable.type; 
                    setInitialValue=$variable.properties."main-properties"."set-initial-value".value; 
                    InitialValue=$variable.properties."main-properties"."initialisation-value".value
                }

                $variables += $variable
           }
        }

        return $variables
    }
}

<#
.SYNOPSIS
Returns returns a list of blocks from a workspace

.DESCRIPTION
Returns returns a list of blocks based on the ID of the workspace containing them, given that this workspace is a state or error state.

.PARAMETER workspaceId
The ID of the workspace to be queried.

.PARAMETER flowPsObject
The contents flow file containing the workspace, converted to a PsCustomObject using the ConvertFrom-JSON cmdlet
#>
function getBlocksFromWorkspace {

    param(
        [string]$workspaceId,
        [psobject]$flowPsObject
    )

    if ((GetWorkspaceType -flowPsObject $flowPsObject -workspaceId $workspaceId -eq "SEQ_STATE") -or (GetWorkspaceType -flowPsObject $flowPsObject -workspaceId $workspaceId -eq "SEQ_ERROR_STATE")) {
        
        $blockList = @()

        foreach ($block in $flowPsObject.Json.$($workspaceId).items) {
        
            #initialise block to consider
            $currentBlock = [CortexBlock]::new()
            $propetiesTable = @{}

            
            #check it's not a connection or variable store
            if ($block.type -ne "draw2d.CortexConnection" -and $block.type -ne "SEQ_VARIABLE_STORE" -and $block.type -ne "draw2d.ErrorConnection") {
                    
                #Add id and type to block
                $currentBlock.blockID = $block.id
                $currentBlock.blockType = $block.type
            
                #User Interface blocks
                if($block.type -eq 'SEQ_FB_DATA_ENTRY') {
	                $UIElements = $flowPsObject.Json.$($block.userData.link).items

                    foreach($element in $UIElements){
                        $propetiesTable += GetBlockProperties -block $element -UIElementName $element.Id
                    }
	
                }

                #add properties
                $propetiesTable += GetBlockProperties -block $block -UIElementName $null
                $currentBlock.properties = $propetiesTable   
                $blockList += $currentBlock
            }
        }

        Return $blockList
    }
}

<#
.SYNOPSIS
Returns returns a list of block connections from a workspace

.DESCRIPTION
Returns returns a list of block connections based on the ID of the workspace containing them, given that this workspace is a state or error state.

.PARAMETER workspaceId
The ID of the workspace to be queried.

.PARAMETER flowPsObject
The contents flow file containing the workspace, converted to a PsCustomObject using the ConvertFrom-JSON cmdlet
#>
function GetConnectionsFromWorkspace {

    param(
        [string]$workspaceId,
        [psobject]$flowPsObject
    )

    if ((GetWorkspaceType -flowPsObject $flowPsObject -workspaceId $workspaceId -eq "SEQ_STATE") -or (GetWorkspaceType -flowPsObject $flowPsObject -workspaceId $workspaceId -eq "SEQ_ERROR_STATE")) {
        $connections = @()

        foreach ($connection in $flowPsObject.Json.$($workspaceId).items) {
            if ($connection.type -eq "draw2d.CortexConnection" -or $connection.type -eq "draw2d.ErrorConnection") {
                $connections += @{
                    source=$connection.source.node;
                    target=$connection.target.node
                }
            }
        }

        return $connections
    }
}

<#
.SYNOPSIS
Translates the text content of a .flow file into a CortexFlow object

.PARAMETER flowFileText
The contents of a .flow file
#>
function TranslateFlowFile {

    param(
        [string]$flowfileText
    )

    #Convert flow file text to PsCustomObject 
    $flowfile = ConvertFrom-Json -InputObject $flowfileText
    #get top workspace
    $topWorkspaceId = $flowFile.Json.firstworkspace

    if($flowFile.Type -eq "Flow"){
        #initialise flow object
        $flow = [CortexFlow]::new()
        $flow.flowName = $flowFile.FlowName
        $flow.FlowId = $flowFile.Id
        #look at each state in the top workspace
        foreach ($stateBlock in $flowFile.Json.$($topWorkspaceId).items) {
        
            #record variable store
            if ($stateBlock.type -eq "SEQ_VARIABLE_STORE") {
        
                $flow.GlobalVariables = GetVariablesFromWorkspace -workspaceId $stateBlock.userData.link -flowPsObject $flowFile
            }
            #record other states/default error handler
            elseif ($stateBlock.type -ne "draw2d.CortexConnection" -and $stateBlock.type -ne "draw2d.ErrorConnection"){            
                #initialise state
                $currentState = [CortexState]::new()

                #set state name, id and blocks
                $currentState.stateID = $stateBlock.userData.link
                $currentState.stateName = $($stateBlock.properties."Main-Properties"."State-Name".value -replace "`(`$`)","")
                $currentState.blocks = $(GetBlocksFromWorkspace -workspaceId $currentState.stateID -flowPsObject $flowFile)

                #find variable store
                foreach ($block in $flowfile.Json.$($currentState.stateID).items) {
                    if ($block.type -eq "SEQ_VARIABLE_STORE") {
                        $varStoreId = $block.userData.link
                    }
                }

                $currentState.variables = $(GetVariablesFromWorkspace -workspaceId $varStoreId -flowPsObject $flowFile -parentWorkspace $currentState.stateID)

                #set links between blocks that have been found
                $blockLinks = GetConnectionsFromWorkspace -workspaceId $currentState.stateID -flowPsObject $flowFile

                #for each link, seach for the blocks at either end and update them.
                foreach ($link in $blockLinks) {
                    foreach ($block in $currentState.blocks) {
                
                        if ($link.source -eq $block.blockId) {
                            $targetBlock = $currentState.getBlockById($link.target)
                            $targetBlock.addSource($link.source)
                            $currentState.replaceBlockbyId($link.target, $targetBlock)
                        }
                        if ($link.target -eq $block.blockId) {
                            $sourceBlock = $currentState.getBlockById($link.source)
                            if ($block.blockType -eq 'SEQ_LOCAL_ERROR_HANDLER'){
                                $sourceBlock.addExceptionHandler($link.target)
                            } else {
                                $sourceBlock.addTarget($link.target)
                            }    
                        
                            $currentState.replaceBlockbyId($link.source, $sourceBlock)
                        }
                    }
                }

                #if we're looking at a state, update the flow accordingly 
                if ($stateBlock.type -eq "SEQ_STATE") {

                    $flow.addState([CortexState]::new($currentState.stateName, $currentState.stateID, $currentState.blocks, $currentState.variables))
                }
                #if we're looking at the default error handler state, update the flow accordingly
                if ($stateBlock.type -eq "SEQ_ERROR_STATE") {
            
                    $flow.updateDefaultErrorHandler([CortexState]::new($currentState.stateName, $currentState.stateID, $currentState.blocks, $currentState.variables))
                }
            } 
        }
        return $flow
    } else {

        $subtask = [CortexSubtask]::new()

        #set state name, id and blocks
        $subtask.subtaskID = $topWorkspaceId
        $subtask.subtaskName = $flowFile.FlowName
        #$blocks = @()
        #$variables = @()
        $links = @()

        foreach($item in $flowFile.Json.$($topWorkspaceId).items){
            if($item.type -eq "SEQ_VARIABLE_STORE"){
                #find variable store workspace
                foreach($variable in $flowFile.Json.$($item.userData.link).items){
                    if ($variable.type -match 'SEQ_VARIABLE') {
  
                        $variableObj = @{
                            varName=$variable.properties."main-properties"."variable-name".value; 
                            varType=$variable.type; 
                            setInitialValue=$variable.properties."main-properties"."set-initial-value".value; 
                            InitialValue=$variable.properties."main-properties"."initialisation-value".value
                        }

                        $subtask.variables += $variableObj
                    }
                }
            } elseif ($item.type -eq "draw2d.CortexConnection" -or $item.type -eq "draw2d.ErrorConnection"){
                $links += @{
                    source=$item.source.node;
                    target=$item.target.node
                }
            } else {

                $currentBlock = [CortexBlock]::new()

                #Add id and type to block
                $currentBlock.blockID = $item.id
                $currentBlock.blockType = $item.type
            
                #add properties
                $propetiesTable = GetBlockProperties -block $item
                $currentBlock.properties = $propetiesTable   
                $subtask.blocks += $currentBlock
            
            }
        
        }

        #for each link, search for the blocks at either end and update them.
        foreach ($link in $links) {
            foreach ($block in $subtask.blocks) {
                
                if ($link.source -eq $block.blockId) {
                    $targetBlock = $subtask.getBlockById($link.target)
                    $targetBlock.addSource($link.source)
                    $subtask.replaceBlockbyId($link.target, $targetBlock)
                }
                if ($link.target -eq $block.blockId) {
                    $sourceBlock = $subtask.getBlockById($link.source)
                    if ($block.blockType -eq 'SEQ_LOCAL_ERROR_HANDLER'){
                        $sourceBlock.addExceptionHandler($link.target)
                    } else {
                        $sourceBlock.addTarget($link.target)
                    }    
                        
                    $subtask.replaceBlockbyId($link.source, $sourceBlock)
                }
            }
        }
        return $subtask        
        
    }
    

    #output CortexFlow object
    
}

<#
.SYNOPSIS
Returns block types and their properties that contain variables as text not as a cortex symbol.
#>
function getPropertiesToInclude {
   
    return '[
        {
            "blockType": "SEQ_FB_START_NEW_SEQUENCE",
            "properties": [
                "parameters-to-copy",
                "parameters-to-exclude",
                "initial-parameters"
            ]
        },
        {
            "blockType": "SEQ_FB_CALL_SEQUENCE",
            "properties": [
                "Send-Variable-Map",
                "Return-Variable-Map"
            ]
        },
        {
            "blockType": "SEQ_FB_SUBTASK",
            "properties": [
                "variables-to-return"
            ]
        }
    ]' | ConvertFrom-Json
}


<#
.SYNOPSIS
Returns block types and their properties that cortex symbols that are not variables e.g. column headings in a table.
#>
function getPropertiesToExclude {
    return '[
        {
            "blockType": "SEQ_FB_TABLE_CREATE",
            "properties": [
                "Primary-Key-Columns",
                "nullable-columns",
                "readonly-columns"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_REMOVE_COLUMNS",
            "properties": [
                "column-names-to-remove"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_SET_RECORD_VALUES",
            "properties": [
                "column-field-names"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_GET_RECORD_VALUES",
            "properties": [
                "column-field-names"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_QUERY_SINGLE_ROW",
            "properties": [
                "query-column-name",
                "value-column-name"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_ADD_COLUMNS",
            "properties": [
                "new-column-names"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_MODIFY_PROPERTIES",
            "properties": [
                "Primary-Key-Columns",
                "nullable-columns",
                "readonly-columns"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_SIMPLE_QUERY",
            "properties": [
                "query-column-name",
                "value-column-name"
            ]
        },
        {
            "blockType": "SEQ_FB_TABLE_RENAME_COLUMN",
            "properties": [
                "column-name",
                "new-column-name"
            ]
        },
        {
            "blockType": "SEQ_FB_LIST_EXTRACT_SUBLIST",
            "properties": [
                "sublist-attribute"
            ]
        }
    ]' | ConvertFrom-Json
}

((getPropertiesToExclude)[1].Properties).GetType()


<#
.SYNOPSIS
Returns different formats a variable name can have in a property dialogue

.DESCRIPTION
Returns a list with the variable name as a Cortex Symbol, variable reference as a Cortex Symbol and the variable cast as text.
Also included are these types as the name of a list and structure.

.PARAMETER variableName
The name of the variable as text not a Cortex symbol, i.e. without the ($) prefix.
#>

function getVariableFormats {
    
    param(
        [string]$variableName
    )

    return  @(
        "(`$)$variableName",
        "(`$)$variableName.",
        "(`$)$variableName`[", 
        "(`$)`$$variableName",
        "(`$)`$$variableName.",
        "(`$)`$$variableName`[",  
        "`{`{$variableName",
        "`{`{$variableName.",
        "`{`{$variableName`["
    )
}

<#
.SYNOPSIS
Returns block names that should be ignored from Description Coverage.
#>
function getBlocksToExcludeFromDescriptionCoverage {
   
    return '[
      "SEQ_FB_EXIT_POINT",
      "SEQ_FB_ENTRY_POINT",
      "SEQ_FB_FREETEXT",
      "SEQ-FB-END-POINT",
      "SEQ-FB-WIRELESS-SENDER",
      "SEQ-FB-WIRELESS-RECEIVER"
    ]' | ConvertFrom-Json
}