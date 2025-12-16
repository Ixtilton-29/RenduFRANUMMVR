---
title:
AUTHOR: juliette 
---
# Readme

## Présentation du Projet

Ce travail vise à constituer un début d'anthologie de la poésie numérique à thématique mythologique, la *mythpoetry*. 

Les textes ici rassemblés sont par nature volatiles et éphémères : jamais édités, souvent hébergés sur des plateformes instables, susceptibles de disparaître ou d’avoir déjà disparu. Un enjeu central de ce travail est donc la traçabilité des œuvres. Il s’agit d’en attester l’existence et d’en documenter les états successifs, dans la mesure du possible, à travers différents types de preuves ou de « témoins » : captures d’écran, codes sources, images source, archives intermédiaires.

La construction de cette anthologie repose initialement sur la mise en place d’une archive personnelle et d’une base de données structurée en XML. Ce premier socle, à la fois outil de travail et espace de conservation, constitue le lieu où s’opèrent les premiers choix de sélection, de délimitation et de représentation des éléments textuels. L'acte d'encodage modélise déjà les frontières de l’œuvre.

L’édition proprement dite constitue une seconde phase, distincte de l’archivage : il s’agit d’une mise à disposition du corpus, rendue possible par une médiation technique et critique, via une transformation XSLT qui permet de générer une interface publique et lisible. Lors de cette étape, certains éléments initialement présents sous forme de liens ou d’instructions acquièrent une dimension graphique et interactive, devenant ainsi partie intégrante de l’expérience de lecture proposée, tandis que d’autres restent en retrait, préservés dans l’archive comme composantes documentaires. 

Ces choix éditoriaux, assumés et documentés, relèvent de la responsabilité de l’éditeur-chercheur, dont le rôle est d’assurer la transparence de l’ensemble du processus, de l’archivage à la publication.

Des choix éditoriaux interviennent également à ce niveau (comme à toutes les étapes du procesus). responsabilité de l'éditeur-chercheur : assurer la transparence du processus. 

### Les commentaires

Cette démarche est accompagnée d’un dispositif de commentaires articulé sur trois niveaux : 

1. Le premier niveau, englobant la préface du site, le présent fichier Readme et la documentation de l’ontologie utilisée, expose le cadre théorique et méthodologique du projet. 

2. Le second niveau prend la forme de notes éditoriales, intégrées aux fichiers XML et rendues visibles sur le site statique, qui explicitent les décisions prises à chaque étape du traitement des textes. 

3. Enfin, un troisième niveau, plus informel et subjectif, est constitué par les commentaires laissés dans le code même des fichiers d’encodage et de transformation. Ces « marginalia numériques », conservés intentionnellement, documentent l’avancée des réflexions, les hésitations, les consignes personnelles et témoignent du degré d’expertise au moment de la réalisation des tâches. Ils forment un carnet de recherche ouvert dans le projet éditorial.

## Description du Corpus

Le corpus est constitué d’un ensemble de textes poétiques numériques aux motifs mythologiques. Ces textes sont des objets poétiques divers. Chacun d'entre eux est encodé dans un fichier XML individuel, respectant les standards de la Text Encoding Initiative. Ils sont accompagnés d’un index d’auteurs, d'un index de personnages et d’un index bibliographique en XML, ainsi que d’un corpus d’images, et de fichier sources.

Chaque ressource (texte, auteur, référence, image) possède un identifiant unique au sein du projet. Les textes et auteurs ont chacun un identifiant xml unique au sein du corpus. Les identifiants, sources et métadonnées des images sont gérées via le logiciel Tropy et stockés dans un fichier JSON-LD.

### Ontologie

#### Schéma conceptuel

    TEXTE POÉTIQUE (produit de la lecture)
        │
    TRANSFORMATION ET MISE A DISPOSITION DU PUBLIC
        │
        │
    ENCODAGE 
        │
        ├── SOURCES 
        │   ├── Post sous format texte → Réf. bib. 1
        │   ├── OU BIEN Post sous format image → Réf. bib. 1  
        │   └── Source imprimée ultérieure → Réf. bib. n2
        │
        ├── TRACES MATÉRIELLES (preuves) 
        │   ├── code Source de la page (technique) 
        │   └── Image témoin (capture d'écran) 
        │
        ├── REPRODUCTIONS  
        │   └── Images témoignant de la diffusion des textes
        │
        └── DIALOGUES INTERTEXTUELS
            ├── Texte en réponse
            └── Images-réponses

#### Classes Principales

Voici les principales classes qui structurent l’ontologie. Leurs propriétés sont détaillées dans le fichier monOnthologie.ttl.

**textePoetique** : Représente un poème numérique. 
**Auteur** : Représente la ou les personnes ayant créé le texte. 
**referenceBibliographique** : Représente la référence bibliographique du texte, en XML-TEI. 
**Image** : Représente une image associée au texte. Cette classe possède des sous-propriétés. 
**codeSource** : Représente le “fichier carrotage” qui documente l’environnement technique du texte au moment de son archivage. 
**Personnage** : personnage mythologique apparaissant dans un texte et renseigné au sein d’un index.

#### Sous-classes

On distingue 5 types d’images : 

1. Les imagesSources : document sur lequel nous nous basons pour l’établissement d’un texte
2. Les imagesDiffusion : images témoignant de la reproduction d’un texte et de sa diffusion
3. Les imagesIllustration : images illustrant et accompagnant un texte
4. Les imagesReponses : Images apparaissant en réponse au texte, engageant un dialogue intertextuel ou intermédial
5. Les imagesTémoins : captures d’écran témoignant de l’état d’un site au moment de la collecte d’un texte ou d’une image

#### Relations principales

- estCreePar : Lien entre un textePoetique et son auteur
- faitReferenceA : Lien entre un textePoetique et un personnage
- aPourReference: Lien entre une referenceBibliographique un textePoetique
- estAssocieA : Lien entre un textePoetique et une imageDiffusion ou son imageReponse
- estDocumenteTechniquementPar : Lien entre un TextePoetique et sa documentation technique (son codeSource)

#### Relations pour chaque type d’image

- estSourceDe : lien entre une image-source et un textePoetique
- estDiffusePar relie un textePoetique aux imageDiffusion
- estDocumentePar relie un textePoetique aux imageTemoin (les captures d’écran documentant).
- repondA relie une imageReponse à un textePoetique

### Structure des Fichiers

    /Corpus_Mythpoetry/
    │
    ├── README.md  
    ├── Index.html  
    ├── feuilleDeStyleAccueil.css  
    │
    ├── ontologie/
    │   └── ontologie.ttl
    │
    └── corpus/
         ├── textes/ (fichiers XML-TEI)
         │   ├── textePoetiqueTitre1.xml
         │   ├── textePoetiqueTitre2.xml
         │   └── ...
         ├── images/                          
         │   ├── imagesDiffusion   
         │   │   ├── NOMAuteurType.png
         │   │   ├── NOMAuteurType.png
         │   │   └── ...
         │   ├── imagesReponses  
         │   │   └── ...
         │   ├── imagesIllustration  
         │   │   └── ...
         │   ├── imagesSources
         │   │   └── ...
         │   └── imagesTemoins
         │       └── ...
         ├── metadonnees/                       
         │    ├── feuilleDeStyleIndex.css
         │    ├── templateIndex.xsl
         │    ├── indexAuteurs.xml
         │    ├── indexAuteurs.xml
         │    ├── indexAuteurs.html
         │    ├── indexBibliographique.xml
         │    ├── indexBibliographique.html
         │    ├── indexImages.json
         │    ├── indexPersonnages.xml
         │    └── indexPersonnages.xml   
         ├── siteMythpoetry/                       
         │    ├── feuilleDeStyle.css
         │    ├── feuilleDeStyleTestLabyrinthe.css
         │    ├── templatePoemes.xsl
         │    ├── templateTest.xsl
         │    ├── textePoetiqueTitre1.html   
         │    └── ...   
         └── codeSource/ 
              ├── codeSourceTexte.html  
              └── ... 

### Conventions d’identifiants

#### Les noms de fichier

1. Les textes : textePoetiqueTitre.xml
2. Les index : IndexSujet.xml
3. Les fichiers images : typeTitreDeLOeuvre1.png
4. Les fichiers carottages : carottage001

#### Les identifiants internes

Les noms des fichiers texte et leur identifiant XML sont identiques.
1. Les textes : textePoetiqueTitre.xml (ex: textePoetiqueKassandraRates)
2. Les images : typeTitreDeLOeuvre1 (ex: TemoinKassandraRates1)
3. Les personnages : NOM (ex: APOLLON)
4. Les références bibliographiques : NomDate (ex: Mulroy2015)
5. Les auteurs : NOM_Prénom (ex: WEE_Natalie)

#### Format utilisés et documentation

1. Encodage des textes : XML-TEI
2. transformation XSLT : processeur Saxon (version)
3. Index des auteurs, personnages et références bibliographiques : XML-TEI. Pour les réf biblio export depuis le logiciel Zotero
4. Fichiers images : .png
5. Métadonnées des images : JSON (export depuis le logiciel Tropy)
6. Code source : fichiers.html
7. Langage de l’ontologie : OWL 2, serialisé en Turtle (.ttl).

Standards TEI : http://www.tei-c.org/
Documentation OWL : https://www.w3.org/OWL/

## Développements futur

Le corpus est appelé à être développé sur plusieurs points : 

1. Extension quantitative. Il s'agira d'intégrer de nouveaux textes et images à l'anthologie. 
2. Métadonnées des images. Un travail technique devra être mené sur le traitement des métadonnées associées aux images, actuellement confronté à des difficultés d'export. 
3. Améliorer l'archivage des codes sources. La stratégie d'archivage des codes sources est amenée à évoluer vers une méthode plus robuste, notamment par l'utilisation d'outils comme l'extension SingleFile, permettant de générer des documents autoportants.

Enfin, à terme, le principal défi conceptuel et technique réside dans la question des template XSL. Faut-il multiplier les templates pour épouser au plus près la singularité formelle de chaque œuvre, au risque de la fragmentation et de la complexité accrue du système ? Ou doit-on viser un template unique, capable de modéliser l'ensemble des textes poétiques au prix potentiel d'une réduction de leur spécificité ? 


