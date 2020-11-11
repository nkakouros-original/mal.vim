" TODO add debug statements as Debug
" TODO rename Mal* names when I know better what each one is, e.g. are
" MaLDirectives really directives or sth else, eg statements?
" TODO rename Block to Scope
" TODO operators should be included in assets only (?)
" TODO folding on brackets is not working nice, fold on "assets", "catergories"
" TODO look into syntax clusters, maybe they simplify things

syntax case match
syntax spell notoplevel

" Operators
syntax match MalOperator "->\||\|<--\|-->\|&\|+>" keepend
syntax region MalBracketed matchgroup=MalOperator start="\[" end="]" containedin=AssociationStatement transparent
syntax match MalBraces "[{}]" keepend
hi default link MalOperator Operator
hi default link MalBraces Operator

" Code blocks
syntax region MalBracesRegion start="{" end="}" transparent

" Directives
syntax match MalDirective /#.*: .*/ contains=MalDirectiveName
syntax match MalDirectiveName "#.*:" nextgroup=MalDirectiveValue contained skipwhite
syntax match MalDirectiveValue "[^ ]\+.*" contained
hi default link MalDirectiveName PreProc
hi default link MalDirectiveValue String

syntax match MalIncludeStatement "include .*" contains=MalIncludeKeyword
syntax keyword MalIncludeKeyword include nextgroup=MalIncludePath contained skipwhite
syntax match MalIncludePath "[^ ]\+.*" contained
hi default link MalIncludeKeyword Include
hi default link MalIncludePath String

" Categories, assets, associations
" syntax region MalClass matchgroup=Statement start="\(asset\|category\) \w\+ {" end="}"
syntax match MalClass "\s*category\s*\w\+"
syntax match MalClass "\s*\(\(abstract\)\s\+\)\=asset\s\+\w\+\s*\(extends \w\+\)\=" contains=MalClassKey
syntax keyword MalClassKey abstract extends contained
" TODO I don't like the semantics here
hi default link MalClass Statement
hi default link MalClassKey StorageClass

syntax region MalAssociationBlock matchgroup=MalAssociationDeclaration start="associations {" end="}" transparent contains=MalAsset,MalAssetLabel,MalCardinality,MalAssociationName,MalInfoElement,MalComment,MalInfoElement
syntax match MalAsset "\w\+" contained
syntax match MalAssetLabel "\[\w\+\]"hs=s+1,he=e-1,ms=s+1,me=e-1 contained
syntax match MalCardinality "\*\|\d\|\(\d\|\*\)\.\.\(\d\|\*\)" contained
syntax region MalAssociationName matchgroup=MalOperator start="<--" end="-->" contained
hi default link MalAssociationDeclaration Statement
hi default link MalAsset Type
hi default link MalAssetLabel Identifier
hi default link MalCardinality Special
hi default link MalAssociationName Structure

" Functions
syntax region TTCDistribution matchgroup=Function start="\w\+(" end=")" contains=Number
syntax match Number "\d\+\.\?" contained

" Details
syntax match StepLine "\(|\|&\)\s\+\w\+\(\s\+@\(hidden\|trace\|debug\)\)\=" contains=StepOperator,Step,MalDebug
syntax match StepOperator "\(|\|&\)" nextgroup=Step contained
syntax region Step start=" " matchgroup=Type end="\w\+" contained nextgroup=MalDebug
syntax match MalDebug "\s\+@\(hidden\|debug\|trace\)" contained extend
hi default link StepOperator Operator
hi default link MalDebug Debug

syntax match MalLabel "\w\+\."me=e-1,he=e-1
hi default link MalLabel Label

" Comments
syntax region Comment start="/\*" end="\*/" contains=Todo,@Spell
syntax region Comment start="//" end=".*" contains=Todo,@Spell
syntax keyword Todo TODO contained

syntax match MalInfoElement "\(user\|developer\|modeler\) info: .*" contains=@Spell,MalInfoLabels,MalInfoContent transparent
syntax match MalInfoLabels "\(user\|developer\|modeler\) info" contained nextgroup=MalInfoContent
syntax match MalInfoContent ":.*"ms=s+1,hs=s+1 contained
hi default link MalInfoLabels Special
hi default link MalInfoContent String

" Syncing
syntax sync match SyncAssociation grouphere MalAssociationBlock "associations"
" This does not work, needs malclass to be a region
" TODO make it a region and also distinguish between categories and assets
" syntax sync match SyncCategory grouphere MalClass "\(asset\|category\)"

let b:current_syntax = 'vim'
