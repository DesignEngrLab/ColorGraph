function GetScores(colorTree ::Array{Int,2})::Vector{Float64}  #::NamedTuple{(:alpha, :beta, :gamma)}
        numRows = size(colorTree, 1)
        numCols = size(colorTree, 2)
        if numCols<2 return NaN end
        global fnEvals+=1
        alpha = 0.0
        beta = 0.0
        gamma = 0.0
        for i=1:numRows
                #fromNode = colorTree[i,1]
                fromNode = i
                toNode = colorTree[i,1]
                if toNode>=fromNode
                        throw(ArgumentError("the colorTree is incorrectly formed as the toNode is larger than the fromNode"))
                end
                toColor = toNode==0 ? 7 : colorTree[toNode,2]
                fromColor = colorTree[fromNode,2]
                alpha += i * alphaScoreMatrix[fromColor, toColor]
                beta += i * betaScoreMatrix[fromColor, toColor]
                gamma += i * gammaScoreMatrix[fromColor, toColor]
        end
        return [alpha, beta, gamma]
        # return numRows .* [alpha, beta, gamma]
end

function GetCombinedScore(colorTree ::Array{Int,2})::Float64
        scores = GetScores(colorTree)
        return LinearAlgebra.norm(scores - target)
end
