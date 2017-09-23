# Disarranged Sentence Reconstruction
### HCI CenTaD 2016 Physics Research Proposal Report

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

### II.2 Main Program

A simplest version of the main program has been implemented. Currently, it can handle some
of the easiest cases, like rearranging "喜欢 我 你" into "我喜欢你". For more complicated
cases like "太阳 在 假装 黄沙滩 上 他 晒 坐", which have the correct answer,
"他假装坐在黄沙滩上晒太阳", this program outputs "他坐在黄沙滩上太阳晒假装". While some of the
words are not in order, some collocations, like "坐在黄沙滩上", has been rearranged
correctly.

---

## III Future Work

### III.1 Main Program

The next step of the project will be to complete and improve our main program. Currently,
not all data available is fed into the program. This is not a lot of work, and will be
done in the first week of the June holiday.

After that, approximately 3 - 4 weeks of time will be allocated to the study and
application of tuning methods. This mainly involves evaluating the output of the program,
and follow a formula to adjust variables in the algorithm, in order to maximise the
accuracy of the program.

### III.2 Features and Extensions

The main program using probability-based algorithms is expected to be finished by July.
After that, the time will be devoted to further improve the results using other methods.
Arrangements by parts of speech can be attempted, as we are always more confident to, for
example, put a noun than a verb behind an adjective.

For each of the methods proposed here, a cycle like what is done for the main program will
be used, from building the program, feeding data, to tuning of variables.

As many methods as time allows will be considered, using the research time from July to
November.

### III.3 Web Setup

By December, a frontend website is expected to be set up and linked to the main program on
the server. This will serve as the final product of the project.

However, upon further evaluation of the timeline, this may be done in an earlier time,
before the addition of features and extensions is completed. In this way, we may be able
to evaluate the user experience of the final product earlier and improve accordingly.

---

## IV Conclusion

The current progress of project has been following the schedule as expected.

Since this project's timeline is quite flexible, as the main program will not be very hard
to build, and how much time is left only determines how well the results can be improved.
According to the current progress, there should be quite much time left for the features
and extensions, and that part can be extended accordingly, allowing more methods to be
considered.

Hence, in general, the project is going on quite fluently, and some fine results shall be
seen later.
