# ColorScore.m is run in ColorGraph.m Calculates the score for a graph and
# passes it back as GraphScore

struct ColorGraphEvaluation
        alphaScoreMatrix::Array{Float64,2}
        betaScoreMatrix::Array{Float64,2}
        gammaScoreMatrix::Array{Float64,2}
        count::Int64
end

        function eval(colorTree ::Array{Int,2})::NamedTuple{(:alpha, :beta, :gamma)}
                numRows = size(colorTree, 1)
                numCols = size(colorTree, 2)
                if numCols<2 return NaN end
                count++
                alpha = beta = gamma = 0.0
                for i=1:numRows
                        #fromNode = colorTree[i,1]
                        fromNode = i
                        toNode = colorTree[i,1]
                        if toNode>=fromNode
                                throw(ArgumentError("the colorTree is incorrectly formed as the toNode is larger than the fromNode"))
                        end
                        toColor = toNode==0 ? 7 : colorTree[toNode,2]
                        fromColor = colorTree[fromNode,2]
                        alpha+=alphaScoreMatrix[fromColor, toColor]
                        beta+=betaScoreMatrix[fromColor, toColor]
                        gamma+=gammaScoreMatrix[fromColor, toColor]
                end
                return NamedTuple{(:alpha, :beta, :gamma),
                Tuple{Float64,Float64,Float64}}
                ((alpha, beta, gamma))
        end
end
