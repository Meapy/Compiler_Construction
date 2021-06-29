; ModuleID = "/Users/danielkrasovski/Documents/code/Thur-Y-D/Compiler Construction/Recursive_Decent_Parser/Attempt2/codegen.py"
target triple = "arm64-apple-darwin20.5.0"
target datalayout = ""

define void @"main"() 
{
entry:
  %".2" = mul i8 2, 2
  %".3" = bitcast [5 x i8]* @"fstr" to i8*
  %".4" = call i32 (i8*, ...) @"printf"(i8* %".3", i8 %".2")
  ret void
}

declare i32 @"printf"(i8* %".1", ...) 

@"fstr" = internal constant [5 x i8] c"%i \0a\00"