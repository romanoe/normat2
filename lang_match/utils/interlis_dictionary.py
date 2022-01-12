import re
import urllib.request


def interlis_model_lexicon(interlis_model):
    """
    :param interlis_model: url of interlis model. for example https://models.geo.admin.ch/ARE/PlansDAffectation_V1_2.ili
    :return: lexicon (list of words) of interlis model
    """
    words = []
    starting_point = False
    last_lines_detected = False
    with urllib.request.urlopen(interlis_model) as ilimodel:
        for line in ilimodel:
            line_utf8 = line.decode('utf-8')
            # Skipping update details and metadata
            if not last_lines_detected:
                if line_utf8.startswith('!!@'):
                    last_lines_detected = True
                    continue
            else:
                if not line_utf8.startswith('!!@'):
                    starting_point = True
            if starting_point:
            # Remove 'TRANSLATION OF $german_model$'
                if 'TRANSLATION' in line_utf8:
                    remove_translation = re.sub(r"TRANSLATION.*(=)",r"\1", line_utf8)
                    words_list = remove_translation.split()
                else:
                    words_list = line_utf8.split()

                for word in words_list:
                    if word:
                        word_without_symbols = re.sub(r"^\W+|\W+$", "", word)
                        if word_without_symbols:
                            words.append(word_without_symbols)
    return words


def interlis_model_dictionary(french_lexicon, german_lexicon):
    """
    :param french_lexicon: lexicon of french model
    :param german_lexicon: lexicon of german model
    :return:
    """
    if len(french_lexicon) == len(german_lexicon):
        unique_translations = set(list(zip(french_lexicon, german_lexicon)))
        translations = [translation for translation in unique_translations if translation[0] != translation[1]]
        return translations
    else:
        raise Exception("I must have missed something when creating the model lexicon!")


def interlis_models_dictionary(*argv):
    """
    Combine different interlis model dictionaries
    :param argv: several interlis model dictionaries
    :return: dictionary of combined model dictionaries
    """
    combined_dictionary = []
    for arg in argv:
        combined_dictionary = combined_dictionary + arg
    return set(combined_dictionary)

