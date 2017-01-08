# Disarranged Sentence Reconstruction
### HCI CenTaD 2016 Physics Research Final Report

Student: Wang Shuwei, 16S6F, Hwa Chong Institution (College)  
Research Mentor: Dr Wang Xuancong, Institute for Infocomm Research, A*STAR  
Teacher In-Charge: Dr Lee Lih Juinn, Hwa Chong Institution (College)

---

## I. Introduction

### I.1 Project Background

In this project, a popular task in primary school Chinese exams, disarranged sentence
reconstruction (词句重组), is studied. This task mainly requests the students to reorder
and re-arrange a list of Chinese words in random order to form a grammatically correct and
meaningful sentence. For example, suppose the following words are given in the question:

    村庄 浓密的 小湖 树林里 那边的 掩隐 在

Then, one reasonable answer will be

    小湖那边的村庄掩隐在浓密的树林里

### I.2 Project Overview

The project's aim is to use state-of-the-art machine learning algorithms to create a program that can
__automatically__ solve such problems with high accuracy, which means, with the
disarranged word lists as input, the program can produce grammatically correct and
reasonable sentences without human assistance. To fit the amount of work and
resources needed within the constraint of the project, we currently limit our
vocabulary to those words which commonly occur in primary school texts, but may consider expanding
the scope in future expansions for general applications.

The final deliverable of this project is a __Python program__ that run at the back-end of a website. People
can input to the program disarranged word lists through the webpage, and for each word list the program will
re-arrange it to produce a reasonable sentence, and display it on the same page.
This website has been set up on the Institute for Infocomm Research's server,
<a href="http://translate.i2r.a-star.edu.sg/word-rearrange.zh.html" style="color: black;">http://translate.i2r.a-star.edu.sg/word-rearrange.zh.html</a>.

### I.3 Project Value

Our project serves as an attempt in helping computer programs understand the word order
conventions in natural languages. Such understanding can be of crucial importance to
various natural language processing applications. For example, this algorithm, if fully
trained with a larger scope of text data, may be useful as an add-on that can increase the
performance of our current machine translation systems by correcting the words order in the translation
result. Take Google Translation as an example, when the sentence "A
program can automatically solve such problems with high accuracy." is translated into
Chinese, the result given by the program is __"程序可以自动解决此类问题具有较高的精度。"__. It
can be observed that the translation is quite accurate only up to word or phrase level,
but the final sentence sounds a bit awkward in its word order, since "较高的精度" (high
accuracy) should be moved to the front to give __"程序可以自动以较高的精度解决此类问题。"__,
instead of staying at the end of the Chinese sentence as it does in the English one.
We expect our project as an attempt to solve this and many similar problems in
contemporary natural language processing applications.

### I.4 Timeline

<table>
<tr><td style="text-align: right">April - May |</td><td>Collect and process raw data</td></tr>
<tr><td style="text-align: right">June Week 1 |</td><td>Complete main program with initial language models</td></tr>
<tr><td style="text-align: right">June Week 2 - 4 |</td><td>Create tuning scripts</td></tr>
<tr><td style="text-align: right">August |</td><td>Create website front-end for final product</td></tr>
<tr><td style="text-align: right">July - November |</td><td>Explore various language models to improve performance</td></tr>
<tr><td style="text-align: right">December |</td><td>Conclude project and finish final report</td></tr>
</table>

---

## II Project Progress

### II.1 Collection of Raw Data

Most of the time in April and May has been used to collect data. Here, data refers to
grammatically correct Chinese sentences in the primary school essay domain. This data will
later be fed into the machine learning algorithm for it to "learn" __language models__, a
term for statistics regarding the use of word and word order in a language. Although the scope of this
project has been limited to sentences of primary school difficulty, there are still
thousands of words that may appear in the problem that our algorithm will attempt to
solve. Hence, a large number of sentences is needed for analysis to create such a model
in which most words in our scope and their common usages have been recorded.

In order to fulfil both the large modelling need and the scope constraint of primary
school difficulty, we have crawled data from an online archive of Chinese primary
school essay, 
<a href="http://www.zuowen.com/" style="color: black;">"作文网" (http://www.zuowen.com/)</a>,
which is a data source that should be highly relavent to the scope of this project. 
During April and May, essays of approximately 11 million Chinese characters has been
downloaded from this website, and from this data pool, about 340,000 grammatically correct
sentences of appropriate lengths have been selected, excluding those one-word-and-full-stop
sentences like "真的！", which do not provide much information on word relations, using
shell utilities ``grep``, ``sed`` and ``awk``. These selected sentences will be later used
for training various models in the following section.

Also, access was given to use some Chinese data owned by Institute of Infocomm Research,
summing up to around 15 million sentences that could be _partially_ relevant to our
project. These data are processed through comparisons with largely relevant data collected
from the aforementioned essay website, and sorted according to their relevance. After
that, the most relevant sentences are combined with the sentences selected from the essays
to form 1 million of __in-domain data__, a term for highly relevant data used for machine
learning. The rest of the sentences, which may not be so relevant to our project, are
grouped into __out-domain data__.

Among data collected by Institute of Infocomm Research, there are files containing common
phrases, rather than sentences. These files could also be useful in providing information
on the reasonable combination of words, but need to be analysed differently from
sentences, because phrases are shorter than sentences, hence cannot provide as much
context in terms of the use of words. Therefore they are separated into another data pool,
namely __lexicon data__.

In addition to all the raw Chinese sentences, 2033 real-world 词句重组 questions and
corresponding suggested answers to them are also collected from various Chinese education
websites. These will be used to evaluate the performance of the program, hence facilitate
the finetuning of our algorithm.

### II.2 Modelling

Language modelling is about collecting word occurrence statistics from a sufficiently
large sample of good quality text. We have attempted to build a few different
types of language models, so that we may be able to combine the advantage of each of the
models. The following sections are an overview of the different language models that we
use in the project.

#### II.2.a Word-based N-gram Language Model

The first language model examined in the project is a probability-based model called
__"n-gram language model"__. This is a very common model used in natural language
processing tasks. This model assumes that in a language, the words that can follow a
given sequence of words form a conditional distribution. If an algorithm can observe such 
trends, it should be able to make conclusions that a sentence where words appear in
commonly seen orders will more likely to make sense than a sentence where words appear in
rarely seen orders. For example, examine the following data:

    我 昨天 看了 一本 数学 书
    小明 不小心 弄丢 了 一本 数学 书
    请 同学 们 翻开 数学 书 到 第 五十 页
    
From these sentences, it can be observed that the phrase "数学 书" can appear very
frequently. Hence, conclusion can be made that if a sentence containing phrase "数学 书" is
usually more reasonable than a sentence containing phrase "书 数学".

With the example above being a simplification, n-gram models actually concerns the
probability of a word being at a position given the n-1 words in front of it. For example,
a 3-gram probability in the above case can describe whether "书" is likely to be the next 
word in a sentence if the two words in front of it are "一本" and "数学", or
mathematically:

    P( (i)th word is "书" | (i-2)th word is "一本" and
                            (i-1)th word is "数学" )
    
which, from the data provided above, should be relatively high.

Using a large data pool, our n-gram model is created by counting occurrences of all 
continuous subsequences of 1 - 5 words in all sentences collected, hence predict 1-gram to
5-gram probabilities for all common word combinations within our scope.

With these data being collected in the language model, we will be able to use the model to
evaluate a hypothetical sentence generated by program. This evaluation is quantified with
the logarithm of the probability of each word following the 4 words in front of it as a
score for the given word, and a sentence's overall score of the summation of the scores of
all words. In this way, the larger the score, the higher the probability that the words
are ordered in a commonly seen order, hence, through our assumption, the probability that
the words form a reasonable and meaningful sentence is also higher.

The scoring process would as well use the 1-gram to 4-gram statistics. They are used as 
back-up data in the "back-off process", where a 5-word sequence in the hypothetical
sentence is never seen in the data used to train the language model, hence no 5-gram
statistic is available for the given context. In this case, a 4-gram probability will be
used, using only 3 words in front of a given word. If even such 4-word sequences does not 
appear, a even shorter words sequence will be queried in the similar process, all the way
down to a 1-gram probability, questioning the mere probability that a word will be used
without context. In this way, the n-gram language model will have enough statistic to give
reasonable scores even when the input sentence is ordered in a way not captured by the
training data pool.

In the whole project, we trained a total of 2 word-based language models, using both
in-domain data and out-domain data. Since lexicon data mainly contain 2-to-3-word phrases,
providing not enough context to calculate 4 and 5 gram probabilities, we did not use it as
a data source for word-based language models.

#### II.1.b Word-based Backward N-gram Language Model

__Backward__ n-gram language model is also used in the project, to evaluate the
possibility of a word at a given location from the words after it. This is to cover some
situations where a word is more closely related to words behind it, hence the relationship
might not be well-represented in a normal language model. For example, consider the
following sentence:

    一群 同学 高兴地 去 学校

In this sentence, if we are to evaluate the placement of "高兴地" as the third word of the
sentence using the normal language model, it is to query the possibility of "高兴地"
appearing after "一群 同学". In fact, this combination should be __quite uncommon__ as
compared to "高兴地" appearing before "去 学校". Hence, by only considering the words in
front, we could be under-estimating the possibility of "高兴地" placed as the third word of
the sentence, and would need the backward language model to correct the scoring.

To train a backward language model, we reused the same training script by feeding every
sentence in a reversed order. For example, if the sentence above is among the training
data, we would feed the following line to the script to create a backward language model:

    学校 去 高兴地 同学 一群

In this way, we will be able to reuse the scoring script as well, because with the model
built with reversed sentences, we can simply query the possibility of "高兴地" in a
backward language model by using the words after it as the context "before" the word. For
example, in this case, the model understands "学校" and "去" as the two words "before" word
"高兴地". Hence, simply query the model in the same way as a normal n-gram language model,
using words "学校" and "去" as context, we can get the possibility of "高兴地" given that
the two words are after it.

In total, we trained 2 word-based backward n-gram language model, each corresponding to
a normal word-based n-gram language model mentioned in the previous section, using both
in-domain data and out-domain data as well.

#### II.1.c Character-based N-gram Language Model

In the project, we also explored a similar language model, the character-based n-gram language
model. It utilises generally same principles and methodology as word-based n-gram
language models, but instead evaluates the probabilities of Chinese characters appearing
given the characters in front of it. It is useful because our word segmenter has limited accuracy,
and the statistics for rare words can be better captured in character-based LMs.

In order to create and use this model, we splited the collected sentences by Chinese 
characters using perl Unicode utilities, and feed into the same language model building
process. For character-based models, lexicon data has a long-enough 4-to-5-character entry
length, hence we created a total of 3 character-based language models with all data available.

#### II.1.d Part-of-Speech-based N-gram Language Model

The last n-gram language model we explored in the project is based on the part-of-speech
(POS) of words in the sentence. In the project, a POS tagger from the Institute of Infocomm
Research is used to obtain the POS tag of every word in
a sentence. This inspires the idea that even if a word is never seen in the data we
collected, we can still determine its likely position given its POS. This is because the
Chinese language always follow some grammar, like an adjective usually comes before a
noun, rendering "漂亮的 花" (where "漂亮的" is an adjective, and "花" is a noun) a reasonable
phrase, and "花 漂亮的" meaningless.

Hence, we attempted to capture such grammar by building n-gram language models purely with
POSes. This stored the possibility, for example, of a noun appearing after a verb and an
adjective. Then, when we try to evaluate a hypothetical sentence produced by a program, we
convert the words to POS before use such models. In this way, even if a word is never seen
in our training sentences, so long as we know that it is commonly used as an adjective, we
can conclude that it will be more likely before a noun than after a noun.

In the project, we created 2 POS-based n-gram language model, from both in-domain and 
out-domain data. Since one word corresponds to one POS exactly, lexicon data was excluded
due to the same lack of 3-to-4-word context as when building normal n-gram language
models.

#### II.1.e Bigram occurrence model

Besides n-gram language models, we also build __bigram occurrence__ models to give our algorithm
special attention to common 2-word collocations in the Chinese language. Since our n-gram
language model starts by considering words sequences of length 5, it may miss collocations
of 2 words that are always used together. Use the same example as discussing n-gram
language models, with the sentence:

    请 同学 们 翻开 数学 书 到 第 五十 页

An n-gram language model may evaluate the placement of "书" by querying its possibility
given that "同学 们 翻开 数学" are in front of it. This may produce a extremely low value,
for example, if in the data fed to the algorithm, "同学 们 翻开 数学 课本" has occured many
more times than "同学 们 翻开 数学 书", despite the fact that "数学 书" itself should already
be recognised a very common phrase.

The bigram occurence model complements the n-gram language model in this aspect, by 
evaluating words' placement only based on the words in front of it. To do this, it counts
the occurence of each pair of adjacent words in the data provided. For example, "数学 书"
may have occured for 100 times. Then, when it comes to evaluation, the model outputs a
score of 0 if the pair has never occured in the training data, and (log _n_)² + 1 times if
the pair has occured _n_ times in the training data. In our case of "数学 书", an occurence
of this 2-word phrase in the hypothetical sentence will be worth a score of
(log 100)² + 1 = 5.

We trained 3 bigram occurence models in our project, all from the same in-domain data set.
Besides the normal occurence model mentioned above, the other 2 are trained using
__POS data__ as well. They are respectively word-pos model, which counts the occurence of
a certain POS after a given word, for example, the occurence of nouns after "漂亮的", and
pos-word model, which on the other side counts the occurence of a given word after certain
POS, for example the occurence of "游戏" after a verb.

We did not train bigram models for out-domain data set due to a consideration of
controlling the maximum number of models. If there are too many models trained and used, a
problem called __overfitting__ may occur. This will be further discussed in the tuning
section.
    
#### II.1.f LSTM-based Recurrent Neural Network Language Model (RNNLM)

Recently, RNNLM is found to be more effective in modeling long and complex sentences (Sundermeyer et al.). The
main drawback of conventional n-gram language model is limited word context coverage. For
example, in a 5-gram language model, only the previous 4 words are used in predicting the
current word. On the other hand, if we increase the n-gram context, to 9 (for example),
there will not be enough training data to learn a good statistics for most of the context
phrases. For example, for a 9-gram language model, consider
P( (i)th word is "五十" | previous 8 words are "请 同学 们 翻开 数学 书 到 第" ),
it is in general very difficult to find an exact match of all the 8 words in the training
data. Even if an exact 8-word match exists by co-incidence, the number of occurrences will
be too few to learn a good statistical distribution. In the case where an exact 8-word match does not
exist, although we can use n-gram backoff, different words will get backed off to different
n-gram orders. This will create inconsistency and discontinuity in the statistical model, causing
the prediction to be good at some words and bad at some other words (especially for large backoffs,
e.g., back-off all the way to unigram).

RNNLM solves this problem by keeping a state vector while going through every words. In this way,
it has an effective context size of infinity and can "remember" every words in the past. The long
short-term memory (LSTM) based neural networks also has a mechanism that can selectively remember
and forget information. For example, "把 ... 带走", in Chinese language, it is common to have
an object followed by a verb after "把", this pattern can be learned by an LSTM-based RNNLM.

In this project, we have trained two Chinese character-based LSTM-based RNNLMs
(one with punctuation, one without punctuation) to complement the
drawback of limited context modelling in n-gram language models.

### II.2 Programming

The programming part considers statistical databases based on the selected models, and
scores a hypothetical answer to a piece of test data. Each model is implemented as a 
__Python module__ with a function ``score(hypothesis)``. They each corresponds a weight,
predetermined using a process called tuning, which will be mentioned in the next section,
and passed to the program as options. The final score is calculated as the __dot product__
of the model scores and corresponding weights. Namely, if the models provide scores _s₁_,
_s₂_, _s₃_..., and their weights are _w₁_, _w₂_, _w₃_... respectively, the final score is
calculated as:

    s = w₁s₁ + w₂s₂ + w₃s₃ + ...

This expression is evaluated through the following pseudocode, given that all models and
their weights has been specified globally:

    function calculate_score (hypo):
    	set final_score to 0
    	for each model in all models:
    		increase final_score by
    		    model.score(hypo) * model.weight
    	end
    	return final_score
    end

With this scoring function, the main program is then implemented to find among all
possible hypothetical answers one that has the highest scores. While it is impossible to
enumerate all possible hypothesis that can be formed with _n_ words, which require as much
as _n_! permutations to be evaluated, it is possible to find a reasonable answer using a
partially greedy intuition, that most Chinese sentences that make sense are made up by 
substrings, or phrases, that are reasonable as well. Hence, these substrings should also
have high scores.

This hints that a high-scoring sentence of _n_ words could be formed by combining one of
the high-scoring phrases of (_n_ - 1) words with the last remaining word, and this 
high-scoring phrase of (_n_ - 1) words could be formed by combining one of the
high-scoring phrases of (_n_ - 2) words with one of the remaining words, and so on.

Hence, we propose for the program to iteratively generate high-scoring phrases of length
1, 2, 3..., each based on the previous iteration's results. Considering the computation
power of our working environment, we limit the high-scoring phrases to the top 100 phrases
with the highest scores, among ones generated from the high-scoring phrases of shorter
length.

With this proposal, we further work out three programs different in phrase generation
directions, and implemented all of them to perform a comparison. They are discussed in the 
following subsections.

#### II.2.a Left-to-Right Generation

The first proposed program generates phrases from left to right. This means, it selects 
the first word randomly, sorts them by scores, filters out the ones with lowest scores if
necessary, and repeats the whole process with the second word, the third word, and so on.
This process can be illustrated using the following pseudocode:

    function generate_hypothesis:
    	init hypos to empty array
    	hypos.append empty string
    	for each index in 1 to n:
    		init new_hypos to empty array
    		for each hypothesis in hypos:
    			for each word in hypothesis.remaining_words:
    				new_hypos.append (hypothesis + word)
    			end
    		end
    		new_hypos.sort by score
    		if new_hypos.contains more than 100 items:
    			set hypos to first 100 items in new_hypos
    		else:
    			set hypos to all items in new_hypos
    		end
    	end
    	return first item in hypos
    end

#### II.2.b Right-to-Left Generation

While left-to-right generation is similar to how people normally form up sentences - we
first think of the subject, then the verb, and the object is usually the last, in some
situations words are not chosen based on the words on its left. For example, if I am to
generate a sentence "一群 同学 高兴地 玩" from left to right, after getting "一群 同学",
we will need to choose from the last three words which word should likely follow as the 
third word, and obviously "一群 同学 玩" will be more reasonable as a phrase as compared
to "一群 同学 高兴地". However, from the other direction, it will be more natural to
determine that "高兴地" should precede after selecting "玩". Hence, we also created the
right-to-left generation algorithm to see which one will have a better general
performance. This algorithm is simply by replacing the statement that appends the new word
on the left:

    new_hypos.append (hypothesis + word)
    
with one that appends the new word on the right:

    new_hypos.append (word + hypothesis)

#### II.2.c Bi-directional generation

Bi-directional generation is one algorithm that considers the generation of phrases in
both directions. We attempted this as we discovered that for some phrases both
left-to-right and right-to-left generation cannot produce the expected result, due to the
fact that some sentences may both words that relate to ones in front of it and those that 
relate to ones after it. One example would be the phrase "玩 这样的 游戏 很高兴". In this 
case, if a program is to generate this answer from the words from left to right, it have
to pick "这样的" as a high-scoring word to follow "玩", while right-to-left generation 
would require picking "游戏" after "很高兴". Both would be a bit unreasonable, since if a
human is to solve this task, a natural thinking process will be to first combine "这样的"
with "游戏", then add the verb "玩" to the left to get "玩 这样的 游戏", and the adverb
"很高兴" comes at the last.

Trying to imitate this natural process, we designed to bi-directional generation to pick
one word to place at the center, and add one word to the hypothesis at a time, trying both
left and right placements, and consider only the 100 best placements for every round,
until all words has been used.

The implementation of bi-directional generation is a bit more complex, since we need to
consider the replication of hypotheses generated this way. For example, if the program 
choose to begin by "我", and adds "是" behind in the next round, and it also includes "是"
as the beginning word, with "我" added in the front, this will generate two identical
hypotheses to be considered in the second round. As a result, the 100 best choices could
be filled with repetitive hypotheses, hence making the buffer less effective in providing
a large range of "high-scoring phrases" than the highest-scoring few phrases which may not
be actually reasonable. Hence, when appending to the list of hypotheses, we need to check
whether the hypothesis is a repetition of a previous one. In pseudocode, this means the
following process:

    if new_hypos.not_contains (word + hypothesis):
    	new_hypos.append (word + hypothesis)
    if new_hypos.not_contains (hypothesis + word):
    	new_hypos.append (hypothesis + word)

### II.3 Tuning

While language models are all built from large amount of data, hence should generally
display all common feathers in Chinese language in our scope of vocabulary and sentence
structures. However, they admittedly each have their own bias to different degrees, and
proper weights need to be used while calculating the final score, to best represent the
degree of reasonableness and meaningfulness of a constructed hypothetical sentence. For
example, if the part-of-speech language model tend to give accurate evaluations of how
well a sentence is crafted, while on the other side, char-based language model could give
misguiding scores at some times, we may need to assign the part-of-speech language model
with a larger weight, while char-based language model is assigned with a smaller one.

Tuning, as the last step in the production of a natural language processing algorithm, is
designed to automate this weight-assigning process.

In order to do tuning, different hypothetical answers to the test questions is first
compared to the correct answer, to evaluate actually to what extent are these answers
correct. This is done using the __BLEU algorithm__ (BiLingual Evaluation Understudy). It
looks at all phrases of a certain length, and considers the precision of the hypothesis.
For example, when considering phrases of length two, precision is calculated as the
percentage of adjacent words pairs in the hypothetical sentence that are indeed adjacent
in the correct answer. A real number BLEU score is calculated as the geometric mean of the
the precision for different phrases lengths.

For example, if a machine outputted answer is "我 喜欢 读 这本 书 漫画", while the actual
answer is "我 喜欢 读 这本 漫画 书", we can have the following table:

                Phrase length:   1   2   3   4
          Total in hypothesis:   6   5   4   3
    Appeared in actual answer:   6   3   2   1
         Calculated precision:   1  0.6 0.5 0.3

Hence, the BLEU score will be the geometric mean of precisions, approximately 0.56.

When we perform tuning, we first provide the the program mentioned in the previous section
with random weights, and collect the list of best hypotheses with their corresponding
final scores from a prepared set of inputs, using the actual task questions we collected 
before. The scores are then compared to the BLEU scores of those hypotheses, and the
tuning script will adjust the guessed weights accordingly to make the final scores conform
with the BLEU scores, which means that the final score should be high for a hypothesis 
with a high BLEU score, and vice versa. This process of regression will be repeated until 
the weights __converge__, which means that no further adjustments larger than a given
lower bound can be made to improve the conformance between the scores, and the resulted
weight will serve as the optimal weight.

#### II.3.a MERT

MERT stands for __minimum error rate tuning__, and is one of the two tuning algorithms we
choose to try in our project.

MERT reads the top hypotheses generated for a number of sample word rearranging tasks
along with their scores based on various models. It then evaluates these hypotheses with
their corresponding reference answers using the BLEU algorithm, corresponding each
hypothesis with an error rate describing how far is it from the correct answer. It adjusts
the weights in such a way that the summation of error rates of the best hypotheses to all
sample tasks, ranked according to computed final scores from the model scores, is
minimised.

In the project, a shell script is produced to repeatedly call this algorithm and save the
adjusted weights for as the initial weights in the next round. It stops if the changes to
the weights in a round is smaller than a predefined threshold, or the total rounds 
performed reaches an upper bound, hence performs tuning to the weights.

#### II.3.b MIRA

MIRA stands for __margin infused relaxed algorithm__, and is the other tuning algorithm we
experimented in the project.

Similar to MERT, MIRA performs its calculations based on top hypotheses for sample tasks,
and their error rates evaluated based on the BLEU algorithm. However, instead of
minimising the error rate of the chosen best hypothesis, the algorithm compares the 
computed final scores of hypotheses with that of the closest hypothesis to the correct
answer, namely the "oracle hypothesis". It then adjust the weights to make sure that the
difference between the final scores of the "bad" hypotheses and the oracle hypothesis are
at least as large as the error rate evaluated from BLEU algorithms, hence making sure that
in an actual run of the problem-solving program, the oracle hypothesis will be chosen as
the highest-scoring answer.

Similarly, a shell script is used in the project to repeat the algorithm for the weights
to converge, hence to complete the tuning process.

#### II.3.c Alternative tuning

Both algorithms are promising in converging the weights to a set of high-performance
values. Hence, we attempted to combine the advantages of both tuning algorithms by
performing the two algorithms alternatively. This means to run one of the algorithms on
odd rounds, and the other on even rounds in the tuning script. However, since the two
tuning algorithms has different tuning objectives, this may cause the weights to vibrate
infinitely without being able to converge. Hence, we decided to script the process in such
a way that after a certain rounds, when the weights are about to settle and the 
adjustments in one rounds are small, the script will stick with one algorithm to let the
weights converge. The threshold is practically set to 30 rounds, given enough alternating
rounds not to let one algorithm dominate the trend of the weight adjustments, while at the
same time make the while tuning process's time cost acceptable.

We utilised all three ways of tuning in our project to produce a few sets of different
"optimal" weights. They will be evaluated and compared in the Results section.

### II.4 Website Setup

Our project choose to present the results in the form of a task-solving website. This is
created using a website template from Institute of Infocomm Research's translation
websites, and allow people to input their own word lists to be rearranged to sentences.
The website communicates with the server through HTTP requests, and PHP scripts are setup
to direct these requests through TCP socket connections to the back-end python script,
which performs the rearranging algorithm. Then, through a reversed sequence of
transmission, the rearranged sentences will be sent to be presented in a text field on the
webpage.

---

## III Results

The completed algorithm used for the webpage service is evaluated using BLEU scores. A
list of sample sentence reconstruction tasks, different from the ones used in tuning, are
solved by the algorithm, and the average BLEU score for the accuracy of the
program-computed answers compared to the correct answers is generated as an accuracy 
evaluation of the algorithm. Gladly, our proposed algorithm has achieved quite high
accuracy of a BLEU score of around 0.75 to 0.80, no matter what aforementioned 
hypotheses-generating or tuning configuration is used. However, different configurations
do lead to small difference in the average BLEU score calculated, and we have attempted to
explore the most effective configuration by adjusting the following aspects of the
algorithm:

__a) Hypotheses generation direction__

As mentioned in section II.2, we have proposed a total of 3 hypotheses generation
directions to be used in the algorithm. We will perform tuning on same model combinations
with all three pieces of generation code, and compare horizontally to identify which one
performs the best.

__b) Tuning algorithm__

Similar to hypotheses generation directions, we have also proposed a total of 3 choices of
tuning algorithms to be used, in section II.3. We will also perform tuning under same
conditions with all three methods, so that we can compare horizontally to evaluation the
performance of different tuning algorithms.

__c) Models used__

In total, we have proposed 11 language models, using data from three data pools: in-domain
data, out-domain data and lexicon data. Among them, some would provide accurate prediction
of how well-crafted a hypothetical answer is, while others could produce misguiding 
statistics. Hence, the selection of models to be used in the algorithm will affect the
accuracy of the results.

Based on both the data used and the type of the language model, we have arranged the 
language models (LM) we trained in the following table.

<style>#models td {
	border: 1px solid black;
	padding: 5px;
}</style>
<table id="models" style="text-align: center; border-collapse: collapse; margin-bottom: 10px">
<tr><td></td><td>In-Domain</td><td>Out-Domain</td><td>Lexicon</td></tr>
<tr><td>Word-Based<br />N-gram</td><td>1 LM</td><td>1 LM</td><td>None</td></tr>
<tr><td>Backward<br />Word-Based<br />N-gram</td><td>1 LM</td><td>1 LM</td><td>None</td></tr>
<tr><td>Char-Based<br />N-gram</td><td>1 LM</td><td>1 LM</td><td>1 LM</td></tr>
<tr><td>POS-Based<br />N-gram</td><td>1 LM</td><td>None</td><td>None</td></tr>
<tr><td>Word-Based<br />Bigram</td><td>1 LM</td><td>None</td><td>None</td></tr>
<tr><td>POS-Based<br />Bigram</td><td>2 LM<br />[Word-POS]<br />[POS-Word]</td><td>None</td><td>None</td></tr>
</table>

In the following sections, for the sake of conciseness, when we mention a certain model
combination, we will be using both a __data tag__ and a __type tag__. Data tags include
"in", "no-lex" and "all". "In" means to use only models built from in-domain data,
"no-lex" means to include both in-domain models and out-domain models, while "all" means
to use language models built from any data source. One the other hand, type tags may be
one of the nine:

_word_: Using only forward word-based n-gram language model, i.e. row 1 in the table above  
_bidir-word_: using word-based n-gram models in both directions, i.e. row 1 and 2 in the table above  
_n-gram-no-pos_: using n-gram language models without POS models, i.e. row 1, 2 and 3 in the table above  
_n-gram-no-backward_: using n-gram language models without backward word-based models, i.e. row 1, 3 and 4 in the table above  
_n-gram_: using all n-gram langugage models, i.e. row 1, 2, 3 and 4 in the table above  
_no-bigram-pos_: using n-gram language models and bigram word-based models, i.e. row 1, 2, 3, 4 and 5 in the table above  
_no-pos_: using all language models without any POS models, i.e. row 1, 2, 3 and 5 in the table above  
_no-backward_: using all language models without backward word-based n-gram models, i.e. row 1, 3, 4, 5, 6 in the table above  
_all_: using all language models, i.e. row 1, 2, 3, 4, 5 and 6 in the table above

For example, a model combination tagged "no-lex/no-pos" would include the 7 language
models in the first 2 columns, and the rows 1, 2, 3 and 5.

This tagging method is designed for easy comparison of different model combinations to 
display effectiveness of single type of language models or single data sources, hence to 
help decide whether inclusion of that model type or data source is helpful in improving
the whole algorithm. For example, if we are to evaluate whether adding backward models
will bring improvement in accuracy, we can simply compare the performance of model
combinations "all/no-backward", and "all/all", since they only differ by this one type of
model.

### III.1 Comparison of hypotheses generation direction

When comparing between different hypotheses generation directions, we found out that as
expected, bi-directional generation usually gives the best results, and could sometimes
get a BLEU score far better than the other two methods. In the 20 best-performing
configurations, __13, or 65%__, uses bi-directional generation.

However, the right-to-left generation method performs surprisingly well as well, despite
the fact that languages tend to be formed from left to right. This method takes all the
remaining 7 positions in the 20 best-performing configurations. Even more, among all 21
different sets of model selections we tested on, with __only two__ of them does
left-to-right generation methods consistently outperforms the right-to-left one, namely
"all/no-backward" and "no-lex/no-backward" model combinations. Among both of these
combinations, word-based backward language models, which provide scoring of hypothetical
answers based on words to the right, hence should be key to right-to-left hypotheses
generation, are missing. In the remaining model combinations, right-to-left generation
method is always a bit better than the left to right ones. We believe this is due to the
reason that in the Chinese language, decorative words like adjectives and adverbs usually
tend to appear to the left of the words they describe. Hence, if we try to generate a 
sentence from left to right, we will usually misplace these decorative words, causing a 
decrease in the result accuracy. This is shown as left-to-right generation constantly
produces results like "小鸡 拍 着 翅膀 向 家里 跑 去 高高兴兴", where the adverb "高高兴兴" is
misplaced at the end, while this rarely occur with right-to-left hypotheses generation.

### III.2 Comparison of tuning methods

When comparing between different tuning methods, we observed that MIRA generally
outperforms both MERT and alternative methods. Among the 20 best-performing configurations
__9, or 45%__ are tuned with MIRA. Even when we consider all configurations tested, in
nearly 50% of the cases algorithms tuned with MIRA receives a higher BLEU score than the
other two methods.

However, we also found out that different tuning methods usually do not affect the final
accuracy a lot, resulting in usually a change of 0.0001 to 0.0005 in the average BLEU
score of the algorithm. From the ranking of all tuned configurations in the appendix, we
can see that especially in the lower half of the table, same model configurations with 
different tuning methods usually come at adjacent rows, indicating that a change in tuning
method rarely brings a larger improvement than a change in model selection or generation
method. However, among the top-scoring configurations, different tuning methods still 
result in vastly different rankings. Hence, we believe this shows that the selection of
tuning methods is still a viable step for improving a natural language processing 
algorithm, but it should be the final step that provides some minimal finetuning after all
the more important choices, like the selection of language models, have been taken care
of.

### III.3 Comparison of models

As we compare the tuning results for different combination of models, there is a
consistent trend of configurations with more models performs better than configurations
with less models, indicating that most models contribute to the improvement of performance
of the algorithm. This is especially shown when compare horizontally between model type
tags like "n-gram" with "n-gram-no-pos" (without POS models) or "n-gram-no-pos" with
"bidir-word" (without char-based models), where no matter what the remaining parts of the
configuration are set to, adding models always improve the BLEU scores.

Some exceptions occur at word-based backward language models and char-based model built 
from lexicon data. While backward language models constantly brings large improvements in
BLEU scores when using right-to-left generation, the change can be not as much, or even
negative when using the other two hypotheses generation methods. This can especially seen
when comparing "bidir-word" and "word" (without backward models) model configurations,
where the addition of backward models consistently improve right-to-left generation 
performance, but cause a drop in the performance of the other two generation methods. This
could be due to that backward models can give erroneous possibility values for the last
few words in a left-to-right generation algorithm because of a lack of sentence-end
context.

For the char-based model built from lexicon data, the inclusion of it does not have much
effect on the BLEU score of the configuration. It can bring a change of around ±0.01 to
the score, increasing or decreasing it in different cases. This renders our lexicon 
language model not very effective in the algorithm, and we believe that this is because
that words and phrases in our lexicon data mostly belongs to a larger scope, including
many political-related phrases and proper nouns, hence do not fit very well in the scope
of our project. Sometimes, it may even tune to a negative weight, indicating that 
appearance of word sequences as in the lexicon data may actually mean that the hypothesis
is not likely an answer to the task.

Hence, we conclude that most language models, built with both in-domain and out-domain
data, are actually helpful for the improvement of the data, with backward language models,
as a special case, are useful only limited to right-to-left generation of hypotheses. On 
the other side, lexicon-based data, if not matching the vocabulary scope of a natural
language processing application well, may not be very useful in building language models.

### III.4 Limitation: Overfitting

__Overfitting__ exists as a limitation of this project, and may render some parts of the
aforementioned observations not very accurate. This is due to the fact that we only
managed to collect 2033 actual disarranged sentence reconstruction tasks, splited into
a 1500-line tuning data used for the tuning algorithm, and a 533-line testing data used
for evaluating different configurations' performance with BLEU scores. On the other side,
we have proposed as much as 11 language models to attempt, leading to as much as 11
weight variables to adjust during tuning. This may cause the weights to be overfitted to
the tuning data during the tuning process, providing very accurate answers for the tasks
in the tuning data, but becoming much less accurate for other data sets, like the testing
data.

The fact that overfitting exists in our tuned weights can be seen through the comparison 
of BLEU scores obtained between using only the testing set and using a combination of the
tuning and testing data sets. While in configurations with small number of models like
"in/bidir-word" (2 models) and "no-lex/bidir-word" (4 models), the difference is around
0.01, the value can be 50% larger, more than 0.015, with larger number of models, like
"all/all" (11 models), indicating that the accuracy raises much more on the tuning data
set.

Also, sometimes models besides the aforementioned lexicon data language model are tuned to
an unreasonable negative weight indicating subtractive contribution to the final score.
This could indicate overfitting as well, since it is unlikely that a hypothetical answer
that scores better in a language model can be generally less likely to be a reasonable
sentence, but this may occur in some special cases where the language models fail to
capture a feature in the Chinese language. A negative value may hint that the weights are
specially tuned to such features appearing in a task during tuning, but instead may not
perform well on the more general cases.

Hence, we believe that in our project, there should be certain degrees of overfitting,
which may affect the accuracy of the results. This project could be further improved in
the future if more data are made available for tuning to verify the accuracy of the 
observations and conclusions.

---

## IV. Conclusion

In conclusion, in this project, a computer algorithm has been developed from raw scratch
using a combination of statistical language models, to solve the famous primary school
Chinese exam task, __disarranged sentence reconstruction__ (词句重组 or 连词成句), automatically. We have 
successfully created a useable web interface that can perform such a task,
and draw various meaningful observations regarding the selection of algorithms, tuning
methods and language models in a natural language processing application. The accuracy of
these findings may be affected by overfitting, due to the limited amount of 
in-domain training data available to our project. However, all the training and tuning
scripts in this project can be easily re-run on a larger data set to obtain more accurate results.

---

## V. Future Extensions

In the future, the project could be repeated after gathering more data, especially actual
sample tasks, to reduce the degree of overfitting in the tuning process, hence achieve
more accurate results.

Also, the project can be extended to other larger scopes. While the algorithm and scripts 
can all be reused, this would require more raw data of grammatically correct sentences in
that respective scope. This could make the final product of the project more useful in
daily use of correcting word order of auto-translated or other machine produced text, 
since the existing project scope of primary school text is still too small to be used 
readily in everyday application.

More broadly, the same concept could be applied to more languages other than Chinese, for
example English, if enough data can be made available to the program. This may result in
a different optimal hypotheses generation direction or a different set of optimal models,
since different languages could have different grammar, conventions and even writing
directions. However, we believe that the findings in this project can be very useful in
such extensions.

---

## References

<style>#ref p {
	margin-left: 20px;
	text-indent: -20px;
}</style>
<div id="ref">

<p>Dustin Hillard and Sarah Petersen. <i>N-gram Language Modeling Tutorial</i>. Retrieved from <a href="http://ssli.ee.washington.edu/WS07/notes/ngrams.pdf" style="color: black;">http://ssli.ee.washington.edu/WS07/notes/ngrams.pdf</a> on Dec 23, 2016</p>
<p>Slava M. Katz. (1987). <i>Estimation of Probabilities from Sparse Data for the Language Model Component of a Speech Recognizer</i>. IEEE Transactions on Acoustics, Speech, and Signal Processing, vol. ASP-35, No. 3, March 1987. Retrieved from <a href="https://pdfs.semanticscholar.org/969a/9ec5f24dabcfb9c70c7ee04625075a6c0a98.pdf" style="color: black;">https://pdfs.semanticscholar.org/969a/9ec5f24dabcfb9c70c7ee04625075a6c0a98.pdf</a> on Dec 23, 2016</p>
<p>Kishore Papineni, Salim Roukos, Todd Ward, and Wei-Jing Zhu. (2002). <i>BLEU: a Method for Automatic Evaluation of Machine Translation</i>. Proceedings of the 40th Annual Meeting of the Association for Computational Linguistics (ACL), Philadelphia, July 2002, pp. 311-318. Retrieved from <a href="http://www.aclweb.org/anthology/P02-1040.pdf" style="color: black;">http://www.aclweb.org/anthology/P02-1040.pdf</a> on Dec 23, 2016</p>
<p>Franz Josef Och. <i>Minimum Error Rate Training in Statistical Machine Translation.</i> Retrieved from <a href="http://www.aclweb.org/anthology/P03-1021" style="color: black;">http://www.aclweb.org/anthology/P03-1021</a> on Dec 23, 2016</p>
<p>Eva Hasler, Barry Haddow, Philipp Koehn. (2011). <i>Margin Infused Relaxed Algorithm (MIRA) for Moses.</i> Retrieved from <a href="http://mt-archive.info/MTMarathon-2011-Hasler.pdf" style="color: black;">http://mt-archive.info/MTMarathon-2011-Hasler.pdf</a> on Dec 23, 2016</p>
<p>Sundermeyer, Martin, Ralf Schlüter, and Hermann Ney. <i>LSTM Neural Networks for Language Modeling.</i> Interspeech. 2012.</p>

</div>

## Appendix: BLEU scores for tuned configurations

<style>#bleu td {
	border: 1px solid black;
	padding: 5px;
}</style>
<table id="bleu" style="text-align: center; border-collapse: collapse; margin-bottom: 10px">
<tr><td>Data Tag</td><td>Type Tag</td><td>Generation<br />Direction</td><td>Tuning<br />Method</td><td>BLEU<br />(only testing data)</td><td>BLEU<br />(with tuning data)</td></tr>
<tr><td>all</td><td>n-gram</td><td>r2l</td><td>Alt</td><td>0.8122</td><td>0.8244</td></tr>
<tr><td>no-lex</td><td>all</td><td>bidir</td><td>MERT</td><td>0.8114</td><td>0.8219</td></tr>
<tr><td>no-lex</td><td>all</td><td>r2l</td><td>Alt</td><td>0.8114</td><td>0.8215</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>bidir</td><td>MIRA</td><td>0.8111</td><td>0.8219</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>bidir</td><td>Alt</td><td>0.8105</td><td>0.8212</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>bidir</td><td>MIRA</td><td>0.8102</td><td>0.8144</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>r2l</td><td>MIRA</td><td>0.8094</td><td>0.8158</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>bidir</td><td>MIRA</td><td>0.8093</td><td>0.8204</td></tr>
<tr><td>all</td><td>all</td><td>bidir</td><td>Alt</td><td>0.8092</td><td>0.8223</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>bidir</td><td>MERT</td><td>0.8089</td><td>0.8224</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>r2l</td><td>MERT</td><td>0.8087</td><td>0.8222</td></tr>
<tr><td>all</td><td>all</td><td>bidir</td><td>MERT</td><td>0.8085</td><td>0.8239</td></tr>
<tr><td>all</td><td>n-gram</td><td>r2l</td><td>MIRA</td><td>0.8082</td><td>0.8174</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>bidir</td><td>Alt</td><td>0.8079</td><td>0.8171</td></tr>
<tr><td>no-lex</td><td>all</td><td>bidir</td><td>MIRA</td><td>0.8076</td><td>0.8203</td></tr>
<tr><td>in</td><td>all</td><td>bidir</td><td>MIRA</td><td>0.8076</td><td>0.8191</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>r2l</td><td>Alt</td><td>0.8075</td><td>0.8222</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>bidir</td><td>Alt</td><td>0.8074</td><td>0.8199</td></tr>
<tr><td>all</td><td>no-backward</td><td>bidir</td><td>MERT</td><td>0.8073</td><td>0.8216</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>r2l</td><td>MIRA</td><td>0.8073</td><td>0.8175</td></tr>
<tr><td>all</td><td>all</td><td>r2l</td><td>Alt</td><td>0.8073</td><td>0.8187</td></tr>
<tr><td>in</td><td>n-gram</td><td>bidir</td><td>MIRA</td><td>0.8071</td><td>0.8126</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>bidir</td><td>Alt</td><td>0.8070</td><td>0.8164</td></tr>
<tr><td>all</td><td>all</td><td>bidir</td><td>MIRA</td><td>0.8069</td><td>0.8217</td></tr>
<tr><td>in</td><td>all</td><td>bidir</td><td>Alt</td><td>0.8068</td><td>0.8183</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>bidir</td><td>MIRA</td><td>0.8068</td><td>0.8147</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>bidir</td><td>MIRA</td><td>0.8068</td><td>0.8151</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>bidir</td><td>MERT</td><td>0.8067</td><td>0.8219</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>bidir</td><td>MERT</td><td>0.8066</td><td>0.8198</td></tr>
<tr><td>in</td><td>all</td><td>bidir</td><td>MERT</td><td>0.8065</td><td>0.8196</td></tr>
<tr><td>all</td><td>no-backward</td><td>bidir</td><td>Alt</td><td>0.8064</td><td>0.8238</td></tr>
<tr><td>all</td><td>no-backward</td><td>bidir</td><td>MIRA</td><td>0.8064</td><td>0.8232</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>bidir</td><td>Alt</td><td>0.8059</td><td>0.8168</td></tr>
<tr><td>all</td><td>n-gram</td><td>r2l</td><td>MERT</td><td>0.8058</td><td>0.8200</td></tr>
<tr><td>all</td><td>n-gram</td><td>bidir</td><td>MERT</td><td>0.8055</td><td>0.8188</td></tr>
<tr><td>in</td><td>n-gram</td><td>r2l</td><td>MIRA</td><td>0.8055</td><td>0.8141</td></tr>
<tr><td>all</td><td>no-backward</td><td>l2r</td><td>MIRA</td><td>0.8054</td><td>0.8158</td></tr>
<tr><td>all</td><td>no-backward</td><td>l2r</td><td>Alt</td><td>0.8054</td><td>0.8158</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>bidir</td><td>MERT</td><td>0.8046</td><td>0.8171</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>r2l</td><td>MIRA</td><td>0.8045</td><td>0.8101</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>r2l</td><td>MIRA</td><td>0.8043</td><td>0.8132</td></tr>
<tr><td>all</td><td>n-gram</td><td>bidir</td><td>MIRA</td><td>0.8041</td><td>0.8173</td></tr>
<tr><td>all</td><td>all</td><td>r2l</td><td>MIRA</td><td>0.8040</td><td>0.8165</td></tr>
<tr><td>in</td><td>no-backward</td><td>r2l</td><td>Alt</td><td>0.8038</td><td>0.8108</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>r2l</td><td>MIRA</td><td>0.8038</td><td>0.8029</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>r2l</td><td>MERT</td><td>0.8036</td><td>0.8057</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>r2l</td><td>Alt</td><td>0.8036</td><td>0.8056</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>r2l</td><td>Alt</td><td>0.8035</td><td>0.8162</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>l2r</td><td>MIRA</td><td>0.8034</td><td>0.8146</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>bidir</td><td>MIRA</td><td>0.8034</td><td>0.8130</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>r2l</td><td>Alt</td><td>0.8034</td><td>0.8084</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>l2r</td><td>Alt</td><td>0.8030</td><td>0.8156</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>r2l</td><td>Alt</td><td>0.8029</td><td>0.8138</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>r2l</td><td>MIRA</td><td>0.8027</td><td>0.8060</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>r2l</td><td>MERT</td><td>0.8026</td><td>0.8080</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>l2r</td><td>MERT</td><td>0.8023</td><td>0.8137</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>r2l</td><td>MIRA</td><td>0.8023</td><td>0.8123</td></tr>
<tr><td>in</td><td>all</td><td>r2l</td><td>Alt</td><td>0.8020</td><td>0.8140</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>r2l</td><td>MERT</td><td>0.8020</td><td>0.8126</td></tr>
<tr><td>all</td><td>n-gram</td><td>bidir</td><td>Alt</td><td>0.8017</td><td>0.8158</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>bidir</td><td>MERT</td><td>0.8017</td><td>0.8143</td></tr>
<tr><td>in</td><td>n-gram</td><td>r2l</td><td>Alt</td><td>0.8017</td><td>0.8130</td></tr>
<tr><td>no-lex</td><td>all</td><td>r2l</td><td>MIRA</td><td>0.8014</td><td>0.8154</td></tr>
<tr><td>in</td><td>no-backward</td><td>bidir</td><td>Alt</td><td>0.8013</td><td>0.8143</td></tr>
<tr><td>all</td><td>no-backward</td><td>r2l</td><td>MIRA</td><td>0.8012</td><td>0.8168</td></tr>
<tr><td>in</td><td>no-backward</td><td>r2l</td><td>MIRA</td><td>0.8007</td><td>0.8091</td></tr>
<tr><td>all</td><td>all</td><td>l2r</td><td>Alt</td><td>0.8006</td><td>0.8162</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>r2l</td><td>MIRA</td><td>0.8005</td><td>0.8136</td></tr>
<tr><td>in</td><td>all</td><td>r2l</td><td>MIRA</td><td>0.8001</td><td>0.8119</td></tr>
<tr><td>all</td><td>all</td><td>l2r</td><td>MERT</td><td>0.7999</td><td>0.8111</td></tr>
<tr><td>all</td><td>no-backward</td><td>r2l</td><td>Alt</td><td>0.7998</td><td>0.8163</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>r2l</td><td>MERT</td><td>0.7998</td><td>0.8067</td></tr>
<tr><td>all</td><td>all</td><td>l2r</td><td>MIRA</td><td>0.7989</td><td>0.8162</td></tr>
<tr><td>no-lex</td><td>all</td><td>l2r</td><td>MIRA</td><td>0.7988</td><td>0.8148</td></tr>
<tr><td>in</td><td>no-pos</td><td>r2l</td><td>Alt</td><td>0.7987</td><td>0.8024</td></tr>
<tr><td>no-lex</td><td>all</td><td>l2r</td><td>Alt</td><td>0.7985</td><td>0.8160</td></tr>
<tr><td>in</td><td>all</td><td>r2l</td><td>MERT</td><td>0.7984</td><td>0.8120</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>r2l</td><td>MERT</td><td>0.7982</td><td>0.8076</td></tr>
<tr><td>in</td><td>n-gram</td><td>bidir</td><td>MERT</td><td>0.7981</td><td>0.8105</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>bidir</td><td>MERT</td><td>0.7980</td><td>0.8106</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>bidir</td><td>Alt</td><td>0.7980</td><td>0.8106</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>r2l</td><td>MIRA</td><td>0.7977</td><td>0.8031</td></tr>
<tr><td>no-lex</td><td>all</td><td>bidir</td><td>Alt</td><td>0.7974</td><td>0.8172</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>r2l</td><td>MERT</td><td>0.7974</td><td>0.8138</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>r2l</td><td>Alt</td><td>0.7973</td><td>0.8128</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>r2l</td><td>Alt</td><td>0.7973</td><td>0.8052</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>r2l</td><td>Alt</td><td>0.7970</td><td>0.8124</td></tr>
<tr><td>in</td><td>n-gram</td><td>r2l</td><td>MERT</td><td>0.7969</td><td>0.8112</td></tr>
<tr><td>in</td><td>no-pos</td><td>r2l</td><td>MERT</td><td>0.7969</td><td>0.8035</td></tr>
<tr><td>in</td><td>n-gram</td><td>bidir</td><td>Alt</td><td>0.7968</td><td>0.8100</td></tr>
<tr><td>in</td><td>no-backward</td><td>bidir</td><td>MERT</td><td>0.7967</td><td>0.8159</td></tr>
<tr><td>in</td><td>no-pos</td><td>r2l</td><td>MIRA</td><td>0.7958</td><td>0.8023</td></tr>
<tr><td>in</td><td>no-backward</td><td>l2r</td><td>MIRA</td><td>0.7947</td><td>0.8047</td></tr>
<tr><td>all</td><td>all</td><td>r2l</td><td>MERT</td><td>0.7945</td><td>0.8139</td></tr>
<tr><td>no-lex</td><td>all</td><td>l2r</td><td>MERT</td><td>0.7939</td><td>0.8084</td></tr>
<tr><td>in</td><td>no-backward</td><td>l2r</td><td>Alt</td><td>0.7939</td><td>0.8057</td></tr>
<tr><td>in</td><td>no-backward</td><td>r2l</td><td>MERT</td><td>0.7932</td><td>0.8067</td></tr>
<tr><td>in</td><td>no-pos</td><td>bidir</td><td>MERT</td><td>0.7927</td><td>0.8019</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>r2l</td><td>Alt</td><td>0.7927</td><td>0.8078</td></tr>
<tr><td>all</td><td>no-backward</td><td>l2r</td><td>MERT</td><td>0.7923</td><td>0.8118</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>bidir</td><td>MIRA</td><td>0.7923</td><td>0.8064</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>bidir</td><td>MIRA</td><td>0.7922</td><td>0.8049</td></tr>
<tr><td>no-lex</td><td>all</td><td>r2l</td><td>MERT</td><td>0.7920</td><td>0.8119</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>r2l</td><td>MERT</td><td>0.7910</td><td>0.8111</td></tr>
<tr><td>in</td><td>no-pos</td><td>bidir</td><td>Alt</td><td>0.7905</td><td>0.8020</td></tr>
<tr><td>no-lex</td><td>no-backward</td><td>r2l</td><td>MERT</td><td>0.7903</td><td>0.8113</td></tr>
<tr><td>in</td><td>all</td><td>l2r</td><td>Alt</td><td>0.7902</td><td>0.8061</td></tr>
<tr><td>all</td><td>no-backward</td><td>r2l</td><td>MERT</td><td>0.7901</td><td>0.8115</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>bidir</td><td>MERT</td><td>0.7897</td><td>0.8060</td></tr>
<tr><td>in</td><td>all</td><td>l2r</td><td>MIRA</td><td>0.7896</td><td>0.8051</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>bidir</td><td>Alt</td><td>0.7895</td><td>0.8058</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>bidir</td><td>Alt</td><td>0.7895</td><td>0.8057</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>l2r</td><td>MIRA</td><td>0.7894</td><td>0.8023</td></tr>
<tr><td>all</td><td>n-gram</td><td>l2r</td><td>MIRA</td><td>0.7893</td><td>0.8009</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>l2r</td><td>MIRA</td><td>0.7892</td><td>0.7966</td></tr>
<tr><td>in</td><td>no-pos</td><td>bidir</td><td>MIRA</td><td>0.7889</td><td>0.7990</td></tr>
<tr><td>in</td><td>all</td><td>l2r</td><td>MERT</td><td>0.7887</td><td>0.8064</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>bidir</td><td>MIRA</td><td>0.7886</td><td>0.7998</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>l2r</td><td>Alt</td><td>0.7884</td><td>0.8033</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>l2r</td><td>MIRA</td><td>0.7881</td><td>0.8003</td></tr>
<tr><td>in</td><td>no-backward</td><td>l2r</td><td>MERT</td><td>0.7879</td><td>0.8017</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>l2r</td><td>MERT</td><td>0.7878</td><td>0.8014</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>l2r</td><td>MERT</td><td>0.7875</td><td>0.8009</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>bidir</td><td>MERT</td><td>0.7872</td><td>0.8029</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>bidir</td><td>Alt</td><td>0.7872</td><td>0.8029</td></tr>
<tr><td>no-lex</td><td>n-gram</td><td>l2r</td><td>MERT</td><td>0.7868</td><td>0.8020</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>l2r</td><td>MERT</td><td>0.7864</td><td>0.7992</td></tr>
<tr><td>all</td><td>n-gram-no-backward</td><td>l2r</td><td>Alt</td><td>0.7862</td><td>0.8003</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>l2r</td><td>MIRA</td><td>0.7859</td><td>0.8003</td></tr>
<tr><td>all</td><td>n-gram</td><td>l2r</td><td>Alt</td><td>0.7855</td><td>0.8015</td></tr>
<tr><td>no-lex</td><td>n-gram-no-backward</td><td>l2r</td><td>Alt</td><td>0.7853</td><td>0.8022</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>bidir</td><td>MERT</td><td>0.7853</td><td>0.8034</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>l2r</td><td>MERT</td><td>0.7852</td><td>0.7971</td></tr>
<tr><td>in</td><td>n-gram-no-backward</td><td>l2r</td><td>Alt</td><td>0.7852</td><td>0.7971</td></tr>
<tr><td>all</td><td>n-gram</td><td>l2r</td><td>MERT</td><td>0.7845</td><td>0.8015</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>l2r</td><td>MIRA</td><td>0.7837</td><td>0.7974</td></tr>
<tr><td>in</td><td>n-gram</td><td>l2r</td><td>MIRA</td><td>0.7837</td><td>0.7973</td></tr>
<tr><td>in</td><td>n-gram</td><td>l2r</td><td>MERT</td><td>0.7824</td><td>0.7971</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>l2r</td><td>MERT</td><td>0.7808</td><td>0.7979</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>l2r</td><td>Alt</td><td>0.7807</td><td>0.7979</td></tr>
<tr><td>in</td><td>no-pos</td><td>l2r</td><td>MERT</td><td>0.7795</td><td>0.7978</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>r2l</td><td>MERT</td><td>0.7794</td><td>0.7865</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>r2l</td><td>Alt</td><td>0.7794</td><td>0.7865</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>l2r</td><td>MIRA</td><td>0.7791</td><td>0.7977</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>l2r</td><td>MIRA</td><td>0.7790</td><td>0.7998</td></tr>
<tr><td>in</td><td>no-pos</td><td>l2r</td><td>MIRA</td><td>0.7787</td><td>0.7919</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>l2r</td><td>MERT</td><td>0.7785</td><td>0.8007</td></tr>
<tr><td>in</td><td>n-gram-no-pos</td><td>l2r</td><td>MIRA</td><td>0.7785</td><td>0.7934</td></tr>
<tr><td>in</td><td>no-pos</td><td>l2r</td><td>Alt</td><td>0.7785</td><td>0.7978</td></tr>
<tr><td>in</td><td>n-gram</td><td>l2r</td><td>Alt</td><td>0.7783</td><td>0.7954</td></tr>
<tr><td>all</td><td>n-gram-no-pos</td><td>l2r</td><td>Alt</td><td>0.7782</td><td>0.7967</td></tr>
<tr><td>in</td><td>no-bigram-pos</td><td>l2r</td><td>Alt</td><td>0.7780</td><td>0.7968</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>l2r</td><td>MERT</td><td>0.7780</td><td>0.7984</td></tr>
<tr><td>in</td><td>bidir-word</td><td>r2l</td><td>MIRA</td><td>0.7776</td><td>0.7789</td></tr>
<tr><td>in</td><td>bidir-word</td><td>r2l</td><td>MERT</td><td>0.7774</td><td>0.7808</td></tr>
<tr><td>in</td><td>bidir-word</td><td>r2l</td><td>Alt</td><td>0.7774</td><td>0.7808</td></tr>
<tr><td>no-lex</td><td>word</td><td>bidir</td><td>MERT</td><td>0.7756</td><td>0.7843</td></tr>
<tr><td>no-lex</td><td>word</td><td>bidir</td><td>Alt</td><td>0.7756</td><td>0.7843</td></tr>
<tr><td>no-lex</td><td>n-gram-no-pos</td><td>l2r</td><td>Alt</td><td>0.7750</td><td>0.7962</td></tr>
<tr><td>no-lex</td><td>word</td><td>bidir</td><td>MIRA</td><td>0.7745</td><td>0.7834</td></tr>
<tr><td>in</td><td>word</td><td>bidir</td><td>MIRA</td><td>0.7741</td><td>0.7806</td></tr>
<tr><td>in</td><td>word</td><td>bidir</td><td>MERT</td><td>0.7741</td><td>0.7806</td></tr>
<tr><td>in</td><td>word</td><td>bidir</td><td>Alt</td><td>0.7741</td><td>0.7806</td></tr>
<tr><td>in</td><td>word</td><td>r2l</td><td>MIRA</td><td>0.7741</td><td>0.7766</td></tr>
<tr><td>in</td><td>word</td><td>r2l</td><td>MERT</td><td>0.7741</td><td>0.7766</td></tr>
<tr><td>in</td><td>word</td><td>r2l</td><td>Alt</td><td>0.7741</td><td>0.7766</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>bidir</td><td>MERT</td><td>0.7728</td><td>0.7845</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>bidir</td><td>Alt</td><td>0.7728</td><td>0.7845</td></tr>
<tr><td>no-lex</td><td>word</td><td>r2l</td><td>Alt</td><td>0.7725</td><td>0.7812</td></tr>
<tr><td>no-lex</td><td>word</td><td>r2l</td><td>MERT</td><td>0.7725</td><td>0.7812</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>r2l</td><td>MIRA</td><td>0.7724</td><td>0.7803</td></tr>
<tr><td>no-lex</td><td>word</td><td>r2l</td><td>MIRA</td><td>0.7718</td><td>0.7809</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>bidir</td><td>MIRA</td><td>0.7694</td><td>0.7819</td></tr>
<tr><td>no-lex</td><td>word</td><td>l2r</td><td>MERT</td><td>0.7689</td><td>0.7808</td></tr>
<tr><td>no-lex</td><td>word</td><td>l2r</td><td>Alt</td><td>0.7685</td><td>0.7808</td></tr>
<tr><td>in</td><td>bidir-word</td><td>bidir</td><td>MERT</td><td>0.7683</td><td>0.7785</td></tr>
<tr><td>in</td><td>bidir-word</td><td>bidir</td><td>Alt</td><td>0.7683</td><td>0.7785</td></tr>
<tr><td>no-lex</td><td>word</td><td>l2r</td><td>MIRA</td><td>0.7682</td><td>0.7796</td></tr>
<tr><td>in</td><td>bidir-word</td><td>bidir</td><td>MIRA</td><td>0.7678</td><td>0.7793</td></tr>
<tr><td>in</td><td>word</td><td>l2r</td><td>MIRA</td><td>0.7634</td><td>0.7714</td></tr>
<tr><td>in</td><td>word</td><td>l2r</td><td>MERT</td><td>0.7634</td><td>0.7714</td></tr>
<tr><td>in</td><td>word</td><td>l2r</td><td>Alt</td><td>0.7634</td><td>0.7714</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>l2r</td><td>MIRA</td><td>0.7614</td><td>0.7799</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>l2r</td><td>Alt</td><td>0.7614</td><td>0.7798</td></tr>
<tr><td>no-lex</td><td>bidir-word</td><td>l2r</td><td>MERT</td><td>0.7611</td><td>0.7807</td></tr>
<tr><td>in</td><td>bidir-word</td><td>l2r</td><td>MIRA</td><td>0.7595</td><td>0.7741</td></tr>
<tr><td>in</td><td>bidir-word</td><td>l2r</td><td>Alt</td><td>0.7556</td><td>0.7744</td></tr>
<tr><td>in</td><td>bidir-word</td><td>l2r</td><td>MERT</td><td>0.7556</td><td>0.7742</td></tr>
<tr><td>in</td><td>no-backward</td><td>bidir</td><td>MIRA</td><td>0.7458</td><td>0.7468</td></tr>
</table>
