<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="tei" version="3.0">

  <xsl:output method="html" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>

  <!-- pour gérer mon dossier obtenu -->
  <xsl:param name="output-dir" select="'questions/'"/>

  <xsl:variable name="metadataPath">../metadonnees/</xsl:variable>

  <xsl:template match="/">

    <xsl:for-each select="//tei:div[@xml:id]">
      <xsl:variable name="current-id" select="@xml:id"/>
      <xsl:variable name="filename" select="concat($output-dir, $current-id, '.html')"/>

      <!-- Création des documents séparés -->
      <xsl:result-document href="{$filename}" method="html">
        <html lang="fr">
          <head>
            <meta charset="UTF-8"/>
            <title>Question <xsl:value-of select="$current-id"/></title>
            <!-- Lien vers mes CSS. Important, le fichier CSS doit être dans le même dossier que les HTML créés -->
            <link rel="stylesheet" type="text/css" href="feuilleDeStyleTestLabyrinthe.css"/>
            <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

            <!-- Script Java (Merci William Bouchard) -->

            <script>
              document.addEventListener("DOMContentLoaded", function () {
              const btn = document.getElementById("bouton-visibilite");
              if (!btn) return;
              
              document.querySelectorAll(".commentaire").forEach(el => {
              el.style.display = "none";
              });
              
              btn.addEventListener("click", () => {
              const commentaires = document.querySelectorAll(".commentaire");
              commentaires.forEach(el => {
              if (el.style.display === "none") {
              el.style.display = "";
              } else {
              el.style.display = "none";
              }
              });
              
              btn.textContent = btn.textContent.includes("Afficher") 
              ? "Masquer les notes d'encodage" 
              : "Afficher les notes d'encodage";
              });
              });
            </script>
          </head>

          <body>
            <!-- Menu de Navigation avec les liens vers mes index -->
            <nav class="main-nav">
              <div class="nav-container">
                <div>
                  <a href="../../index.html" class="nav-home">
                    <i class="fas fa-home"> </i>Accueil </a>
                </div>
                <div class="nav-links">
                  <a href="{$metadataPath}IndexAuteurs.html">
                    <i class="fas fa-users"> </i>Index des Auteurs</a>
                  <a href="{$metadataPath}IndexPersonnages.html">
                    <i class="fas fa-user-friends"> </i>Index des Personnages </a>
                  <a href="{$metadataPath}IndexBibliographique.html">
                    <i class="fas fa-book"> </i>Index Bibliographique </a>
                  <button id="bouton-visibilite" class="notes-toggle">
                    <i class="fas fa-sticky-note"/> Afficher les notes d'encodage </button>
                </div>
              </div>
            </nav>

            <!-- Le corps du poème -->
            <main class="poem-container">
              <header class="poem-header">
                <h1 class="poem-title">
                  <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </h1>
                <p class="poem-author">
                  <xsl:apply-templates select="//tei:author" mode="link"/>
                </p>
              </header>

              <!-- Titre de la question -->
              <div class="question" id="{$current-id}">

                <!-- Contenu de la question -->
                <xsl:apply-templates select="node()"/>

                <!-- Navigation (création du bouton next -->
                <div class="navigation">
                  <xsl:apply-templates select="." mode="navigation"/>
                </div>
              </div>
            </main>

            <!-- Pied de page avec les métadonnées -->
            <footer class="metadata-panel">
              <div class="metadata-container">
                <h3 class="metadata-title">
                  <i class="fas fa-info-circle"/> Métadonnées du document</h3>

                <div class="metadata-grid">
                  <!-- Fiche d'identification du texte -->
                  <div class="metadata-column">
                    <h4 class="metadata-subtitle">Identification</h4>
                    <div class="metadata-item">
                      <span class="metadata-label">Titre</span>
                      <span class="metadata-value">
                        <xsl:value-of select="//tei:titleStmt/tei:title"/>
                      </span>
                    </div>
                    <div class="metadata-item">
                      <span class="metadata-label">Auteur</span>
                      <span class="metadata-value">
                        <xsl:apply-templates select="//tei:author" mode="link"/>
                      </span>
                    </div>
                    <div class="metadata-item">
                      <span class="metadata-label">Identifiant au sein du Corpus</span>
                      <code class="metadata-value">
                        <xsl:value-of select="//tei:sourceDesc/@xml:id"/>
                      </code>
                    </div>
                  </div>

                  <!-- Référencement du texte  -->
                  <div class="metadata-column">
                    <h4 class="metadata-subtitle">Sources et références</h4>
                    <div class="metadata-item">
                      <span class="metadata-label">Source bibliographique</span>
                      <span class="metadata-value">
                        <xsl:apply-templates select="//tei:bibl" mode="link"/>
                      </span>
                    </div>
                    <div class="metadata-item">
                      <span class="metadata-label">Ontologie</span>
                      <a href="../../ontologie/monOntologie.ttl" class="metadata-link">
                        <i class="fas fa-project-diagram"/> Voir l'ontologie </a>
                    </div>
                  </div>

                  <!-- Documents associés -->
                  <div class="metadata-column">
                    <h4 class="metadata-subtitle">Documents associés</h4>
                    <xsl:apply-templates select="//tei:listObject"/>
                  </div>
                </div>
              </div>
            </footer>
          </body>
        </html>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>

  <!-- Templates pour le contenu. Je les dinstingue pour les différencier dans le CSS -->

  <xsl:template match="tei:body">
    <div class="poem-body">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div[not(@type) and not(parent::tei:div[@type = 'distractions'])]">
    <div class="poem-stanza">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Les propositions -->
  <xsl:template match="tei:div[@type = 'proposition']">
    <div class="proposition">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Les consignes -->
  <xsl:template match="tei:div[@type = 'consigne']">
    <div class="consigne">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Les bannière des "trending-tests" -->
  <xsl:template match="tei:div[@type = 'baniere_trending']">
    <div class="trending-banner">
      <a href="{substring-after(tei:link/@target, ' ')}" class="external-link" target="_blank">
        <span class="trending-text">
          <xsl:value-of select="tei:p"/>
        </span>
      </a>
    </div>
  </xsl:template>

  <!-- Les autres 'distractions' VERIFIER DANS LE CSS QU ON LES MET BIEN EN BAS DE LA PAGE
  vérifier s'il va chercher le texte p à l'intérieur de la balise div ou n'importe quel autre texte-->
  <xsl:template match="tei:div[@type = 'distractions']">
    <div class="distractions">
      <xsl:apply-templates select="tei:div"/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div[@type = 'distractions']/tei:div">
    <div class="distraction-item">
      <a href="{substring-after(tei:link/@target, ' ')}" class="external-link" target="_blank">
        <span class="trending-text">
          <xsl:value-of select="tei:p"/>
        </span>
      </a>
    </div>
  </xsl:template>

  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:l">
    <div class="poem-line">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:lb">
    <br class="line-break"/>
  </xsl:template>

  <!-- Rajouter le bouton NEXT : essai abandonné 
      <xsl:apply-templates/>
      <xsl:choose>
        <xsl:when poem-stanza="//tei:div[contains('@ana')]">
          <a next="#Q11">NEXT</a>
        </xsl:when>
      </xsl:choose> -->

  <!-- Solution finale pour la navigation via le bouton NEXT-->
  <xsl:template match="tei:div" mode="navigation">
    <xsl:if test="@next">
      <xsl:variable name="next-id" select="replace(@next, '^#', '')"/>
      <xsl:variable name="next-exists" select="//tei:div[@xml:id = $next-id]"/>
      <xsl:if test="$next-exists">
        <a href="{$next-id}.html" class="next-button"> NEXT → </a>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Pas d'index de questions. Cela est volontaire. 
  Un aspect important de cet objet c'est son irréversibilité (on ne peut pas retourner en arrière, il faut tout recommencer depuis le début. 
  C'est un aspect important car il conditionne la performance de la lecture, l'expérience qu'on fait de ce texte. 
  On doit le faire sans s'arrêter, il est impossible d'avoir du recul, du surplomb, cela renforce l'aspect interminables des questions.  -->

  <!-- Template pour les listes de choix -->
  <xsl:template match="tei:list">
    <ul class="choices-container">
      <!-- J'ai supprimé l'utilité de cette classe qui me permettait d'isoler visuellement ce passage typé dans le XML par "choices"
      Faut il un rendu visuel qui suivrait le texte ? Ou bien too much ? Choix graphique qui oriente l'expérience de lecture-->
      <xsl:for-each select="tei:item">
        <li class="choice-item">
          <label class="choice-label">
            <input type="radio" name="question-choice" value="{position()}"/>
            <span class="choice-text">
              <xsl:apply-templates/>
            </span>
          </label>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Template pour les noms de personnages -->
  <xsl:template match="tei:persName">
    <xsl:choose>
      <xsl:when test="@corresp">
        <xsl:variable name="charId" select="substring-after(@corresp, '#')"/>
        <a href="{$metadataPath}IndexPersonnages.html#{$charId}" class="character-link">
          <xsl:apply-templates/>
          <i class="fas fa-external-link-alt character-icon"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span class="character-name">
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Template pour les noms d'auteur -->
  <xsl:template match="tei:author" mode="link">
    <xsl:variable name="authorId" select="substring-after(@ref, '#')"/>
    <a href="{$metadataPath}IndexAuteurs.html#{$authorId}" class="author-link">
      <xsl:value-of select="."/>
      <i class="fas fa-external-link-alt author-icon"/>
    </a>
  </xsl:template>

  <!-- Template pour les références bibliographiques -->
  <xsl:template match="tei:bibl" mode="link">
    <xsl:variable name="biblId" select="substring-after(@corresp, '#')"/>
    <a href="{$metadataPath}IndexBibliographique.html#{$biblId}" class="bibl-link">
      <xsl:text>Voir la référence</xsl:text>
      <i class="fas fa-external-link-alt bibl-icon"/>
    </a>
  </xsl:template>

  <!-- Template pour la liste des objets (images, code source) -->
  <xsl:template match="tei:listObject">
    <xsl:for-each select="tei:object">
      <div class="metadata-item">
        <span class="metadata-label">
          <xsl:choose>
            <xsl:when test="@type = 'imageTémoin'">
              <i class="fas fa-image"/> Témoin du moment de la collecte du texte</xsl:when>
            <xsl:when test="@type = 'imageDiffusion'">
              <i class="fas fa-image"/> Témoin de la diffusion du texte sur le web</xsl:when>
            <xsl:when test="@type = 'imageSource'">
              <i class="fas fa-image"/> Image source</xsl:when>
            <xsl:when test="@type = 'codeSource'">
              <i class="fas fa-code"/> Code source</xsl:when>
            <xsl:otherwise>
              <i class="fas fa-file"/> Document</xsl:otherwise>
          </xsl:choose>
        </span>
        <a href="{tei:objectIdentifier/tei:idno/@corresp}">
          <xsl:value-of select="tei:objectIdentifier/tei:objectName"/>
        </a>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!-- Template pour les images  -->
  <xsl:template match="tei:graphic">
    <div class="image-container">
      <img src="{@url}" alt="Illustration de la question" class="question-image"/>
      <xsl:if test="parent::tei:figure/tei:figDesc">
        <div class="image-caption">
          <xsl:value-of select="parent::tei:figure/tei:figDesc"/>
        </div>
      </xsl:if>
      <xsl:if test="contains(@url, 'timer_icon')">
        <div class="timer-notice">
          <i class="fas fa-clock"/>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- Template pour les interface d'écriture -->
  <xsl:template match="tei:figure[@type = 'interface_ecriture']">
    <div class="writing-interface" data-question-id="{ancestor::tei:div[@xml:id]/@xml:id}">
      <div class="writing-instructions"> </div>
      <div class="writing-input-container">
        <textarea class="writing-textarea" id="textarea_{generate-id()}"
          placeholder="Écrivez votre réponse ici..." rows="5"
          oninput="saveAnswer('{ancestor::tei:div[@xml:id]/@xml:id}', 'textarea_{generate-id()}')"/>
      </div>
      <div class="writing-hint"> </div>
    </div>
  </xsl:template>
  
  
  <!-- Template pour les notes d'encodage -->
  <xsl:template match="tei:note">
    <div class="commentaire">
      <div class="commentaire-header">
        <i class="fas fa-comment-alt"></i> Note d'encodage
      </div>
      <div class="commentaire-content">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>
  

</xsl:stylesheet>
