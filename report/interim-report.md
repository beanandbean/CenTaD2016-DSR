# Disarranged Sentence Reconstruction
### HCI CenTaD 2016 Physics Research Interim Report

Student: Wang Shuwei, 16S6F, Hwa Chong Institution (College)  
Research Mentor: Dr Wang Xuancong, Institute for Infocomm Research, A*STAR  
Teacher In-Charge: Dr Lee Lih Juinn, Hwa Chong Institution (College)

---

## I. Introduction

### I.1 Project Background

In this project, a popular task in primary school Chinese exams, disarranged sentence
reconstruction (词句重组), is examined. This task mainly requests the students to combine
a list of Chinese words of random order into meaningful sentences. For example, if the
following list is given in the question:

    村庄 浓密的 小湖 树林里 那边的 掩隐 在

Then, one reasonable answer will be

    小湖那边的村庄掩隐在浓密的树林里

### I.2 Project Overview

Our aim is to use machine learning algorithms to create a program that can automatically
solve such problems with high accuracy. We currently limit our scope of words to only
those commonly involved in primary school texts, but may consider expanding the scope if
there is enough time and resources for that.

The final product will be python program that run at the backend of a website. People will
be allowed to input to the program disarranged word lists through a webpage, and the
program will produce a reasonable sentence using the input words, and display it on the
same page.

### I.3 Project Value

This program, if fully developed with a larger scope of words, may be useful as an add-on
that can increase the performance of our current translation systems. Take Google
Translation as an example, when the sentence "A program can automatically solve such
problems with high accuracy." is translated into Chinese, the result given by the program
is __"程序可以自动解决此类问题具有较高的精度。"__. It can be observed that quite accurate
translation of every word in English is appearing in the Chinese translation, but the
sentence sounds a bit awkward, since "较高的精度" (high accuracy) should be moved to the
front to give __"程序可以自动以较高的精度解决此类问题。"__. Hence, a program that can take care
of the rearranging of the words will be quite helpful in this case.

### I.4 Timeline

April - May: Collect and process raw data  
June Week 1: Complete main program  
June Week 2 - 4 (and beginning of July): Perform tuning  
July onwards: Add features to further improve performance  
Year End Holiday: Put program onto website

---

## II Work Done So Far

### II.1 Collection of Raw Data

Most of the time in April and May has been used to collect data. Here, data refers to
grammatically correct sentences of Chinese words in our desired scope. This data will
later be fed to the machine learning algorithm for it to "learn" what should be the
correct order of words. A very large amount of data will be needed in this situation,
since in this project, algorithms based on probability is to be utilised, hence a lot of
sentences will need to be examined before the program can make conclusions like whether
word A or word B is more likely to follow word X.

This part has been mostly done by now. A data pool of approximately 11 million Chinese
characters has been fetched from Chinese primary school essay website "作文网"
(http://www.zuowen.com/), which is a data source that should be highly relavent to the
scope of this project. From this pool, about 130,000 sentences has been selected to feed
into the algorithm. Also, access was given to some Chinese data collected by Institute of
Infocomm Research, summing up to a few million sentences that could be _partially_
relevant to our project.

In addition to all the raw essay sentences, 1198 real 词句重组 questions and the suggested
answers to them are also collected. These will be used to evaluate the performance of the
program, hence facilitate the finetuning of the algorithm.

### II.2 Machine Learning Cycle

Machine Learning for Natural Language Processing tasks is usually performed in the
following cycle form:

     Modelling
         |
    Programming
         |
      Tuning
         |
     Modelling (2nd cycle)
         |
        ...

Where in each cycle, the model and algorithm are improved to achieve higher efficiency.
Till now, the first cycle has been completed, and the project is currently in the
modelling part of the second cycle. Following rounds will be significantly less
time-consuming, as there has been enough familiarity with the process.

What work has been done for each of the rounds will be discussed in the following
sections:

#### II.2.a Modelling

Modelling is about summarising language features from the raw data collected. In the first
cycle, a probability-based model called __"n-gram language model"__, is used where the
frequencies of appearance of every phrase is computed and used to predict the possibility
that certain words appear together in the test data.

For example, examine the following data:

    我 昨天 看了 一本 数学 书 。
    小明 不小心 弄丢 了 一本 数学 书 。
    请 同学 们 翻开 数学 书 到 第 五十 页。
    
It can be observed that the phrase "数学 书" appears very frequently. From such frequency
counts, conclusion can be made that if "数学" and "书" are encountered in the test data, it
will be highly likely that they are adjacent in the correct answer.

#### II.2.b Programming

The programming part considers a database based on the selected model, in the case of the
first cycle, a file containing all phrases and their frequencies of appearance in the raw
data collected, and scores a hypothetical answer to a piece of test data. Using the
probability-based model, in the first cycle of this project, the hypothesis is scored by
multiply the probability of appearance of each word given the words in front.

For example, for the following answer:

    我 眺望 着 的 风景 远处
    
It can be expected that there are a few cases of using adjectives to describing "风景" in
our raw data, because it is a fairly common usage. Hence, "... 的 风景" should have a
relatively higher frequency of appearance, therefore be assigned a higher possibility. On
the contrary, "风景 远处" is not even grammatically correct, hence would not appear in our
raw data. Hence, "... 风景 远处" should have a relatively low possibility. By multiplying
all possibilities, what is calculated is the possibility that all words appear in the
correct sentence at the same location as in the hypothesis.

With this scoring function, the main program is then implemented to enumerate through the
different permutations of the words to find the one with the highest possibility, and
claims it as the most possible answer.

#### II.2.c Tuning

Tuning is the last step in a cycle. This step has an aim to balance the different models
built. Its effect may be more significant in later cycles when different models like 
character-based and part-of-speech-based models are involved. In the current cycle, what
is done is to use the Machine Learning algorithm to emphasise on the less biased source
of data.

The bias comes from a difference in focus of the sources. For example, if we have a source
that gives more attention to politics than we expected, for words not related to politics,
like "风景", there will be a lower frequency of appearance, hence a bias possibility is
generated.

Tuning provides balance and emphasises on the more accurate models by generating a series
of parameters _θ₁_, _θ₂_, _θ₃_... Suppose models derived from the data sources provide
scores _s₁_, _s₂_, _s₃_... respectively, the final score will be calculated as a linear
combination of the scores
 
    s = θ₁s₁ + θ₂s₂ + θ₃s₃ + ...
    
If a certain model does not provide accurate result as some times, then its corresponding
parameter can be decreased to reduce the effect it have on the final score of the
sentence.

In order to do tuning, different hypothetical answers to the test questions is first
compared to the correct answer, to evaluate actually to what extent are these answers
correct. This is done using the __BLEU algorithm__. It looks at all phrases of a certain
length, and considers the precision and recall of the hypothesis. For example, when 
considering phrases of length two, precision is calculated as the percentage of adjacent
words pairs in the hypothetical sentence that are indeed adjacent in the correct answer,
while recall is calculated as the percentage of adjacent word pairs in the correct answer
that appears to be adjacent as well in the hypothesis. A real number BLEU score is 
outputted by the algorithm, taking into consideration precision and recall value for
various phrase lengths.

For a number of computer generated hypothesis of the test problems, the scores calculated
using different models are calculated and compared to the BLEU scores of these hypothesis.
The optimal set of parameters that minimises the difference between the final scores given
by linear combination and the BLEU scores is then computed using regression.

After that, the scoring function in the main program is updated to use the linear
combination with the optimal set of parameters to score the hypothesis. This marks the
completion of one Machine Learning cycle.

---

## III Future Work

### III.1 Features and Extensions

From now on, the cycles will be repeated with new ideas for models, like character-based
and part-of-speech-based models as mentioned above. For example, part-of-speech-based
models considers whether nouns or adjectives are more likely to appear after a verb. This
could help handle the cases where a word does not appear in the raw data, hence has no
data for frequency of appearance, which is needed to calculate probability.

As many methods as time allows will be considered, using the research time from July to
November.

### III.2 Web Setup

By December, a frontend website is expected to be set up and linked to the main program on
the server. This will serve as the final product of the project.

However, upon further evaluation of the timeline, this may be done in an earlier time,
before the addition of features and extensions is completed. In this way, we may be able
to evaluate the user experience of the final product earlier and improve accordingly.

---

## IV Conclusion

The first cycle is finished quite on time, with the tuning done in the first week of July.
The accuracy of the current model, as expected, is not very high. It can rearrange simple
sentences correctly. However, as the sentence gets more complex, it tends to misplace some
uncommon words that is rarely seen in the raw data.

There is a few months to continue with more cycles, and I believe that with the time
provided, more features can be added using different types of models, and further improve
the quality of the outputted sentence.
