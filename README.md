# CenTaD 2016 - Disarranged Sentence Reconstruction

## Data collection

Raw essay data are not uploaded due to size considerations. If provided, they should be placed under path ``data-raw/EssayData/www.zuowen.com/``. Raw out-domain data are not uploaded for similar reasons. They should be provided under path ``data-outdomain-raw/``, with suffices ``-sent.zh`` for sentence lists, and ``-lex.zh`` for lexicon data.

``build-lm.sh`` should then be used to train language models into path ``data/``. It creates all n-gram and bigram language models discussed in the final report. This requires following utility scripts to be found under system path:

 - ``xml2txt.sh`` for removing XML tags in a file
 - ``fw2hw-all.sh`` for changing full-width characters to corresponding half-width characters
 - ``lowercase.perl`` for changing uppercase characters to corresponding lowercase characters
 - ``trim.sh`` for removing whitespaces from beginning and end of lines
 - ``segmenter.zh-elus.sh`` and ``desegmenter.zh.sh`` as word segmenter and desegmenter
 - ``POStagger.zh.sh`` as word part-of-speech tagger
 - ``select-parallel-by-Lucene.sh`` for sort a sentence list by relevance to another
 - ``train_languagemodel_kenlm_unk.sh`` and ``train_languagemodel_kenlm_backward_unk.sh`` for training n-gram language models

These utilities are provided on an I2R server during the research.

## Main Program

The main program is ``decoder.py``, invoked through ``decoder.sh`` under running condition. This requires a specified configuration that has been tuned with optimal weights present in folder ``tuning/``. To run the program in multi-thread mode, utility script ``multi-thread.py`` has to be present under system path to start multiple instances of a shell executable.

The main program reads standard input line by line as input tasks, and writes its answers to standard output line by line. One can pipe standard input and output to TCP ports to implement a backend for the sentence rearranging website as demonstrated on the I2R website.

## Tuning

To perform tuning for a custom configuration, one has to produce a file ``tuning/result-<conf_name>.modules`` containing names of selected models among python modules under path ``modules/``. Default configuration files can be generated using script ``feature-sets.py``.

Tuning can be performed with ``tuning.sh``, given that the following utility scripts are found under system path:

 - ``multi-thread.1-line-to-1-linegroup.py`` for multi-thread of shell executables that input by lines and output by linegroups
 - ``mert`` and ``kbmira`` as tuning algorithms
 
Tuning can also be automatically performed on all existing configurations using ``tuning-all.sh``. This will also test all tuned weights with ``check-result.sh``. After testing, all available test results can be gathered as ``results/collected.txt`` with ``collect-result.sh``. A sample test result for all default configurations generated during research is provided in the repository for reference.
