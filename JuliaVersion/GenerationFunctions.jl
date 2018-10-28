
function GenerateRandomly(mods::Int; cand::Array{Int,2}=zeros(Int,0,2))::Array{Int,2}
    if (mods<0)
        cand=cand[1:end+mods,:]
    else
    for i=1:mods
        if (size(cand,1)==0) cand = [0 rand(1:numColors)]
        else cand=vcat(cand, [rand(1:size(cand,1)) rand(1:numColors)])
    end
end
end
    return cand
end

function ExhaustiveHillClimbing(mods::Int; cand::Array{Int,2}=zeros(Int,0,2))::Array{Int,2}
    if (mods<0)
        cand=cand[1:end+mods,:]
    else
    for i=1:mods
        testCand = vcat(cand, [0 0])
        numLocations = size(cand, 1)
        permutations = repeat(0:numLocations,inner=numColors)
        numLocations+=1
        permutations = hcat(permutations, repeat(1:numColors,outer=numLocations))
        bestScore = typemax(Float64)
        bestIndex = 0
        for j=1:numColors*numLocations
            testCand[numLocations,:]=permutations[j,:]
            score = GetCombinedScore(testCand)
            if (score < bestScore)
                bestScore = score
                bestIndex = j
            end
        end
        cand=vcat(cand, permutations[bestIndex:bestIndex,1:2])
    end
end
    return cand
end
