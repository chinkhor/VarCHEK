# VarCHEK

VarCHEK is a prototype tool for checking consistency between variability requirements and source code.

## Download VarCHEK (Linux only):

    git clone https://github.com/chinkhor/VarCHEK.git
    cd VarCHEK

## Evaluation

Evaluate VarCHEK on axTLS:

    ./analyzeAxtls.sh

Evaluate VarCHEK on cFE TIME (TIME module of NASA cFS):

    ./analyzeCfs.sh

Evaluate VarCHEK on BusyBox Editors module:

    ./analyzeEditors.sh

Evaluate VarCHEK on BusyBox Coreutils module:

    ./analyzeCoreutils.sh

## Notes:

The scripts above will run the following automatically:

     1. Download source code from repository
     2. Generate variability model from requirements 
     3. Identify variability source code and presence conditions for variability
     4. Check consistency between variability model and presence conditions
     5. Report consistency 
     6. Find minimum set of configurations that covers variability source code

