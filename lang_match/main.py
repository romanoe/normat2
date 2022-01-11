import sys
from io import open
import re
import csv

def words(interlis_file):
    """
    :param interlis_file:
    :return: unique words in interlis file
    """
    words = []
    domain = False
    with open(interlis_file) as file:
        for line in file:
            if '  DOMAIN' in line:
                domain = True
            if domain:
                words_list = line.split()
                for word in words_list:
                    if word:
                        word_without_symboles = re.sub(r"^\W+|\W+$", "", word)
                        if word_without_symboles:
                            words.append(word_without_symboles)
    return words


def table_dictionary(file_lang_1, file_lang_2):
    """
    :param file_lang_1:
    :param file_lang_2:
    :return:
    """
    if len(file_lang_1) == len(file_lang_2):
        unique_translations = set(list(zip(file_lang_1, file_lang_2)))
        translations = [translation for translation in unique_translations if translation[0] != translation[1]]
        return translations
    else:
        print('Words do not correspond')


def dictionary(*argv):
    translated = set().union(argv)
    return translated


if __name__ == '__main__':
    translations = table_dictionary(words('interlis_fr.ili'), words('interlis_de.ili'))
    with open('dictionary.csv', 'w') as output:
        csv_out = csv.writer(output)
        csv_out.writerow(['french', 'german'])
        csv_out.writerows(translations)

