import csv
from io import open
from utils.interlis_dictionary import interlis_model_dictionary, interlis_model_lexicon, interlis_models_dictionary

if __name__ == '__main__':
    degre_de_sensibilite_au_bruit = interlis_model_dictionary(interlis_model_lexicon('http://models.geo.admin.ch/BAFU/DegreDeSensibiliteAuBruit_V1_2.ili'), interlis_model_lexicon('http://models.geo.admin.ch/BAFU/Laermempfindlichkeitsstufen_V1_2.ili'))
    plans_affectation = interlis_model_dictionary(interlis_model_lexicon('https://models.geo.admin.ch/ARE/PlansDAffectation_V1_2.ili'), interlis_model_lexicon('https://models.geo.admin.ch/ARE/Nutzungsplanung_V1_2.ili'))
    zones_reservees = interlis_model_dictionary(interlis_model_lexicon('https://models.geo.admin.ch/ARE/Zones_reservees_V1_1.ili'), interlis_model_lexicon('https://models.geo.admin.ch/ARE/Planungszonen_V1_1.ili'))
    etat_equipement = interlis_model_dictionary(interlis_model_lexicon('https://models.geo.admin.ch/ARE/Etat_de_l_equipement_V1.ili'), interlis_model_lexicon('https://models.geo.admin.ch/ARE/Stand_der_Erschliessung_V1.ili'))
    distance_foret = interlis_model_dictionary(interlis_model_lexicon('https://models.geo.admin.ch/BAFU/DistancesParRapportALaForet_V1_2.ili'), interlis_model_lexicon('https://models.geo.admin.ch/BAFU/Waldabstandslinien_V1_2.ili'))
    limite_foret = interlis_model_dictionary(interlis_model_lexicon('https://models.geo.admin.ch/BAFU/LimitesDeLaForet_V1_2.ili'), interlis_model_lexicon('https://models.geo.admin.ch/BAFU/Waldgrenzen_V1_2.ili'))

    normat2_dictionary = interlis_models_dictionary(degre_de_sensibilite_au_bruit, plans_affectation, zones_reservees, etat_equipement, distance_foret, limite_foret)

    with open('normat2_dictionary.csv', 'w', newline='') as output:
        csv_out = csv.writer(output)
        csv_out.writerow(['french', 'german'])
        csv_out.writerows(normat2_dictionary)

