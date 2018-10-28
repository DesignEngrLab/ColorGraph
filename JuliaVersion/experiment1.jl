numTests = 5
maxDepth = 50
numColors = 6
target = [100.0, 100.0, 100.0]
fnEvals=0
# alphaScoreMatrix = 10 .* rand(numColors+1,numColors+1) .- 5
# betaScoreMatrix = 10 .* rand(numColors+1,numColors+1) .- 5
# gammaScoreMatrix = 10 .* rand(numColors+1,numColors+1) .- 5

using LinearAlgebra
using Plotly
include("EvaluationFunctions.jl")
include("GenerationFunctions.jl")
#generate = GenerateRandomly
generate = ExhaustiveHillClimbing

scores = Array{Float64, 2}(undef, numTests, maxDepth)
for i=1:numTests

global    alphaScoreMatrix = 10 .* rand(numColors+1,numColors+1) .- 5
global    betaScoreMatrix = 10 .* rand(numColors+1,numColors+1) .- 5
global    gammaScoreMatrix = 10 .* rand(numColors+1,numColors+1) .- 5
        testTree1 = generate(1)
    scores[i,1]= GetCombinedScore(testTree1)
    for j=2:maxDepth
        testTree1 = generate(1, cand=testTree1)
        scores[i,j]= GetCombinedScore(testTree1)
    end
end

plot(transpose(scores))
