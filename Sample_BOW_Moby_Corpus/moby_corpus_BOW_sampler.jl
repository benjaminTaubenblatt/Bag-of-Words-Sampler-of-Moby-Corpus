

# returns a list of the frequency of each element of vocab in tokens
function getWordCounts(vocab,tokens)
    return map(x->countWordFrequency(x,tokens),vocab)
end

# returns a list of the unique values in tokens
function getVocab(tokens)
    return unique(tokens)
end

# normalizes params
function normalize(params)
    total = sum(params)
    return map(x -> x/total, params)
end

# flips a coin with probability p
function flip(p)
    if (rand(1:100,1)[1] < (p * 100))
        return true
    else
        return false
    end
end

# returns a single value based on the vocab outcomes and the distribution params
function sampleCategorical(outcomes,params)
        if flip(params[1])
            return outcomes[1]
        else
            if length(outcomes) == 1
                sampleCategorical(outcomes,normalize(params))
            else
                sampleCategorical(outcomes[2:endof(outcomes)],
                    normalize(params[2:endof(params)]))
            end
        end
end

# returns a list of length len based on the vocabulary vocab and distribution prob
function sampleBowSentence(len,vocab,prob)
    list = []
    for i=1:len
        list = vcat(list, sampleCategorical(vocab, prob))
    end
    return list
end

# returns probability of word in list
function calculateWordProbability(word, list)
    return trunc(countWordFrequency(word,list)/length(list),3)
end

# returns the count of word in list
function countWordFrequency(word,list)
    count = 0
    for i=1:endof(list)
        if list[i] == word
            count = count + 1
        end
    end
    return count
 end

# returns a tokenized a string
function tokenize(str)
    counter = 1
    list = []
    for i=1:endof(str)
      if str[i] == ' '
          if str[counter:i-1] != "" # condition for new sentences : <example>. I eat food.
              list = vcat(list,str[counter:i-1])
              counter = i+1
          else # Otherwise move cursor forward but don't add an element
              counter = i+1
          end

      elseif str[i] in(['.',',',';',':','!','?', # list of punctuation
                        '$','#', '&', '(',')','+',
                        '-','/','*','%','^', '='])
                        if str[counter:i-1] != ""
                            list = vcat(list,str[counter:i-1])
                        end
                        list = vcat(list,str[i:i])
                        counter = i+1
      end
    end
    return list
end

file = open("moby.txt")
mobyText = readstring(file)
close(file)

mobyTokens = tokenize(mobyText)
mobyVocab = getVocab(mobyTokens)
mobyWordCount = getWordCounts(mobyVocab,mobyTokens)
mobyProbs = normalize(mobyWordCount)

for i=1:20
    println(sampleBowSentence(3,mobyVocab,mobyProbs))
end
