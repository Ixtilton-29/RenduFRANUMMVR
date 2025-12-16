<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="tei" version="3.0">


  <xsl:output method="html" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>

  <xsl:variable name="metadataPath">../metadonnees/</xsl:variable>

  <xsl:template match="/">
    <html lang="fr">
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="//tei:titleStmt/tei:title"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="//tei:author"/>
        </title>
        <!-- Lien vers mes CSS. Important, le fichier CSS doit être dans le même dossier que les HTML créés -->
        <link rel="stylesheet" type="text/css" href="feuilleDeStyle.css"/>
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
                <i class="fas fa-users"/> Index des Auteurs</a>
              <a href="{$metadataPath}IndexPersonnages.html">
                <i class="fas fa-user-friends"/> Index des Personnages </a>
              <a href="{$metadataPath}IndexBibliographique.html">
                <i class="fas fa-book"/> Index Bibliographique </a>
              <button id="bouton-visibilite" class="notes-toggle">
                <i class="fas fa-sticky-note"/> Afficher les notes d'encodage </button>
            </div>
          </div>
        </nav>

        <!-- Le corps du poème -->
        <main class="poem-container">
          <header class="poem-header">
            <h1 class="poem-title">
              <xsl:value-of select="//tei:title"/>
            </h1>
            <p class="poem-author">
              <xsl:apply-templates select="//tei:author" mode="link"/>
            </p>
          </header>
          <div>
            <xsl:apply-templates select="//tei:body"/>
          </div>
        </main>

        <!-- Pied de page avec les métadonnées -->
        <footer class="metadata-panel">
          <div class="metadata-container">
            <h3 class="metadata-title">
              <i class="fas fa-info-circle"/> Métadonnées du document </h3>

            <div class="metadata-grid">
              <!-- Fiche d'identification du texte -->
              <div class="metadata-column">
                <h4 class="metadata-subtitle">Identification</h4>
                <div class="metadata-item">
                  <span class="metadata-label">Titre :</span>
                  <span class="metadata-value">
                    <xsl:value-of select="//tei:title"/>
                  </span>
                </div>
                <div class="metadata-item">
                  <span class="metadata-label">Auteur :</span>
                  <span class="metadata-value">
                    <xsl:apply-templates select="//tei:author" mode="link"/>
                  </span>
                </div>
                <div class="metadata-item">
                  <span class="metadata-label">Identifiant au sein du Corpus :</span>
                  <code class="metadata-value">
                    <xsl:value-of select="//tei:sourceDesc/@xml:id"/>
                  </code>
                </div>
              </div>

              <!-- Référencement du texte  -->
              <div class="metadata-column">
                <h4 class="metadata-subtitle">Sources et références</h4>
                <div class="metadata-item">
                  <span class="metadata-label">Source bibliographique :</span>
                  <span class="metadata-value">
                    <xsl:apply-templates select="//tei:bibl" mode="link"/>
                  </span>
                </div>
                <div class="metadata-item">
                  <span class="metadata-label">Ontologie :</span>
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
  </xsl:template>

  <!-- Templates pour le contenu -->
  <xsl:template match="tei:body">
    <div class="poem-body">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="tei:div">
    <div class="poem-stanza">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <!-- J'ai un truc Chelou là, à vérifier pq j'ai mis des p et pas des div déjà ? -->
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
    <br/>
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
              <i class="fas fa-image"/> Témoin du moment de la collecte du texte : </xsl:when>
            <xsl:when test="@type = 'imageDiffusion'">
              <i class="fas fa-image"/> Témoin de la diffusion du texte sur le web : </xsl:when>
            <xsl:when test="@type = 'imageSource'">
              <i class="fas fa-image"/> Image source : </xsl:when>
            <xsl:when test="@type = 'codeSource'">
              <i class="fas fa-code"/> Code source : </xsl:when>
            <xsl:otherwise>
              <i class="fas fa-file"/> Document : </xsl:otherwise>
          </xsl:choose>
        </span>
        <a href="{tei:objectIdentifier/tei:idno/@corresp}">
          <xsl:value-of select="tei:objectIdentifier/tei:objectName"/>
        </a>
      </div>
    </xsl:for-each>
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

  <xsl:template match="tei:*">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
