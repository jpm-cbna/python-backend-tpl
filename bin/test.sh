#!/bin/bash
TOKEN_ENDPOINT="https://dev-taxon-concept.eu.auth0.com/oauth/token"
AUTH0_ID_DATA='{"client_id":"weVvoNG2RR6ES8qfkE02hFywiJWh5hCn","client_secret":"tnlMRuntyJiBi9rcIRN_oJgGnUePuinavxIUiD4s8xLV0Au_PsHC_A4DABmtLoYJ","audience":"https://api-tc.clapas.org","grant_type":"client_credentials"}'
AUTH0_RESPONSE=$(curl --silent -H "Content-Type: application/json" -X POST -d "${AUTH0_ID_DATA}" "${TOKEN_ENDPOINT}")
JWT=$(echo "${AUTH0_RESPONSE}" | jq --raw-output ".access_token")

# Create a new description
description=$(cat <<EOF
3. Lixus brevirost1'is BOH., 1836, in Schonherr, Gen. Cure., III, p. 21. -
na nus Boh., 1. c., p. 22. - crelaceus CHEVR., Rev. Zoo!., 1866, p. 28. -
HUSTACHE, 1927, p. 521. - Cat. SAINTE-CLAIRE-DEVILLE, p. 403.
Long.: 5-6 mm. Allongé, subplan, à pubescence dorsale extrêmement fIne, cendrée, ne voilant pas entièrement les téguments noirs
et luisants; plus rarement recouvert d'une pollinosité jaune et serrée;
antennes (sauf la massue), les genoux, les tibias et les tarses rougeâtres.
Dessous à pubescence plus dense et plus visible. Rostre droit, bien plus
épais que les profémurs, plus court que le prothorax dans les deux sexes,
pubescent, densément ponctué. Front convexe, pourvu d'un gros point
enfoncé. Scape arqué, claviforme au sommet; funicule à 1er article
obconique, plus long que le 2e, celui-ci conique, les suivants très serrés,
transversaux. Yeux grands, arrondis, acuminés inférieurement, faiblement
convexes. Prothorax subconique, un peu plus long que large, ses côtés
presque droits, sa base bisinuée, l'impression antéscutellaire peu marquée,
la ponctuation fIne et serrée. Élytres parallèles, aussi larges que le prothorax (mâle), ou un peu élargis en arrière et légèrement plus larges que
le prothorax (femelle), impressionnés de chaque côté à la base; les muerons
apicaux courts, aigus, triangulaires, leur bord interne rectiligne; stries
fmes à points assez gros, serrés, les deux premières stries plus profondes
à la base et au sommet. Pattes courtes: fémurs faiblement claviformes ;
tarses courts.
Vit sur Atriplex halimus L. (MARQUET, CHOBAUT) (1).
Région méditerranéenne; remonte jusque dans le Lyonnais et au Puy-deDôme (BAYLE, DESBROCHERS). Assez rare.
Vaucluse: Morières, Pernes, Folard, St-Saturnin (CHOBAUT !). - Gard:
Les Angles (CHOBAUT!); Grau du Roi (CABANÈS). - Bouches-du-Rhône:
Marseille (ABEILLE !). - Hérault: Castelnau (H. LAVAGNE !). - Aude:
Narbonne; La Nouvelle (MARQUET). - Pyrénées-Orientales: Collioures
(NORMAND). - Corse: Ajaccio (Dr VELH, cité par HUSTACHE).
Espagne, Sicile, Algérie, Tunisie, Maroc.
EOF
)

curl -X POST \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$JWT  \
    -d "{
  \"mnemonic\": \"Lixus brevirostris\",
  \"rank\": \"SP\",
  \"rawText\": \"${description//$'\n'/\\n}\"
}" http://0.0.0.0:5000/descriptions

# Retrieve descriptions
#curl http://0.0.0.0:5000/descriptions
