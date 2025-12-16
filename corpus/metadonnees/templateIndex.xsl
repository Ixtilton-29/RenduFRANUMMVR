<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei" version="3.0">

    <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"
        omit-xml-declaration="yes"/>

    <!-- Détecter le type d'index -->
    <xsl:variable name="indexType">
        <xsl:choose>
            <xsl:when
                test="contains(lower-case(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title), 'auteur')">
                <xsl:text>auteurs</xsl:text>
            </xsl:when>
            <xsl:when
                test="contains(lower-case(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title), 'personnages')">
                <xsl:text>personnages</xsl:text>
            </xsl:when>
            <xsl:when
                test="contains(lower-case(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title), 'bibliographique')">
                <xsl:text>bibliographique</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>

    <!-- Titre de la page -->
    <xsl:variable name="pageTitle">
        <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
    </xsl:variable>

    <xsl:template match="/">
        <html lang="fr">
            <head>
                <meta charset="UTF-8"/>
                <title>
                    <xsl:value-of select="$pageTitle"/>
                </title>
                <!-- Mes CSS -->
                <link rel="stylesheet" type="text/css" href="feuilleDeStyleIndex.css"/>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                />
                
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
                <!-- Menu de Navigation -->
                <nav class="main-nav">
                    <div class="nav-container">
                        <div>
                            <a href="../../index.html" class="nav-home">
                                <i class="fas fa-home"> </i>Accueil </a>
                        </div>
                        <div class="nav-links">
                            <a href="IndexAuteurs.html">
                                <i class="fas fa-users"> </i>Index des Auteurs </a>
                            <a href="IndexPersonnages.html">
                                <i class="fas fa-user-friends"> </i>Index des Personnages </a>
                            <a href="IndexBibliographique.html">
                                <i class="fas fa-book"> </i>Index Bibliographique </a>
                            <button id="bouton-visibilite" class="notes-toggle">
                                <i class="fas fa-sticky-note"/> Afficher les notes d'encodage
                            </button>
                        </div>
                    </div>
                </nav>

                <!-- En-tête -->
                <header class="page-header">
                    <h1 class="page-title">
                        <xsl:value-of select="$pageTitle"/>
                    </h1>
                    <p class="page-subtitle">
                        <xsl:choose>
                            <xsl:when test="$indexType = 'auteurs'"> Liste des auteurs référencés </xsl:when>
                            <xsl:when test="$indexType = 'personnages'"> Répertoire des personnages
                                mythologiques cités </xsl:when>
                            <xsl:when test="$indexType = 'bibliographique'"> Références
                                bibliographiques des textes </xsl:when>
                        </xsl:choose>
                    </p>
                </header>

                <!-- Index  -->
                <main>
                    <xsl:choose>
                        <xsl:when test="$indexType = 'bibliographique'">
                            <xsl:apply-templates select="//tei:biblStruct" mode="list"/>
                        </xsl:when>
                        <xsl:when test="$indexType = 'personnages'">
                            <xsl:apply-templates select="//tei:person" mode="list"/>
                        </xsl:when>
                        <xsl:when test="$indexType = 'auteurs'">
                            <xsl:apply-templates select="//tei:person" mode="list"/>
                        </xsl:when>
                    </xsl:choose>
                </main>
            </body>
        </html>
    </xsl:template>

    <!-- Index Personnages et Index Auteurs-->
    <xsl:template match="tei:person" mode="list">
        <div class="index-item" id="{@xml:id}">
            <div class="anchor-target" id="{@xml:id}"/>
            <div class=".person-name">
                <xsl:apply-templates select="tei:persName" mode="display"/>
            </div>

            <div class="index-item-content">

                <!-- Nom -->
                <div class="field">
                    <span class="field-label">Identifiant : </span>
                    <span class="field-value">
                        <xsl:value-of select="@xml:id"/>
                    </span>
                </div>

                <!-- Occupation -->
                <xsl:if test="tei:occupation">
                    <div class="field">
                        <span class="field-label">Occupation : </span>
                        <span class="field-value">
                            <xsl:value-of select="tei:occupation"/>
                        </span>
                    </div>
                </xsl:if>

                <!-- Sexe -->
                <xsl:if test="tei:sex">
                    <div class="field">
                        <span class="field-label">Genre : </span>
                        <span class="field-value">
                            <xsl:choose>
                                <xsl:when test="tei:sex = 'female'">Féminin</xsl:when>
                                <xsl:when test="tei:sex = 'male'">Masculin</xsl:when>
                            </xsl:choose>
                        </span>
                    </div>
                </xsl:if>

                <!-- Références bibliographiques liées aux auteurs dans l'index auteur -->
                <xsl:if test="tei:bibl">
                    <div class="field">
                        <span class="field-label">Référence bibliographiques associées :</span>
                        <div>
                            <xsl:for-each select="tei:bibl">
                                <xsl:variable name="biblId" select="substring-after(@corresp, '#')"/>
                                <a href="IndexBibliographique.html#{$biblId}" class="link-bibl">
                                    <xsl:value-of select="position()"/>
                                    <xsl:if test="contains(@corresp, '#')"> (ID: <xsl:value-of
                                            select="substring-after(@corresp, '#')"/>) </xsl:if>
                                </a>
                            </xsl:for-each>
                        </div>
                    </div>
                </xsl:if>

            </div>
        </div>
    </xsl:template>

    <!-- Index Références bibliographiques -->
    <xsl:template match="tei:biblStruct" mode="list">
        <div class="index-item bibl-item" id="{@xml:id}">
            <div class="anchor-target" id="{@xml:id}"/>

            <div class="index-item-id">
                <xsl:value-of select="@xml:id"/>
                <xsl:if test="@type">
                    <span>
                        <xsl:value-of select="@type"/>
                    </span>
                </xsl:if>
            </div>

            <div class="index-item-content">
                <!-- Titre principal -->
                <div class="bibl-title">
                    <xsl:choose>
                        <xsl:when test="tei:monogr/tei:title">
                            <xsl:value-of select="tei:monogr/tei:title"/>
                        </xsl:when>
                        <xsl:when test="tei:analytic/tei:title">
                            <xsl:value-of select="tei:analytic/tei:title"/>
                        </xsl:when>
                    </xsl:choose>

                    <!-- Titre court -->
                    <xsl:if test="tei:monogr/tei:title[@type = 'short']">
                        <span> («<xsl:value-of select="tei:monogr/tei:title[@type = 'short']"/>»)
                        </span>
                    </xsl:if>
                </div>

                <!-- Auteur -->
                <xsl:if test="tei:monogr/tei:author or tei:analytic/tei:author">
                    <div class="bibl-author">
                        <xsl:apply-templates
                            select="tei:monogr/tei:author | tei:analytic/tei:author" mode="bibl"/>
                    </div>
                </xsl:if>

                <!-- Détails -->
                <div class="bibl-details">
                    <!-- Titre de l'ouvrage (pour les sections) -->
                    <xsl:if test="tei:analytic/tei:title and tei:monogr/tei:title">
                        <div>
                            <em>
                                <xsl:value-of select="tei:monogr/tei:title"/>
                            </em>
                            <xsl:if test="tei:monogr/tei:edition"> (<xsl:value-of
                                    select="tei:monogr/tei:edition"/>) </xsl:if>
                        </div>
                    </xsl:if>

                    <!-- Date -->
                    <xsl:if test="tei:monogr/tei:imprint/tei:date">
                        <div>
                            <xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
                        </div>
                    </xsl:if>

                    <!-- URL -->
                    <xsl:if test="tei:monogr/tei:imprint/tei:note[@type = 'url']">
                        <a href="{tei:monogr/tei:imprint/tei:note[@type='url']}" class="bibl-url"
                            target="_blank">disponible en ligne</a>
                    </xsl:if>
                </div>

            </div>
        </div>
    </xsl:template>

    <!-- Afficher les noms des personnes (personnages et auteurs) -->
    <xsl:template match="tei:persName" mode="display">
        <xsl:choose>
            <xsl:when test="tei:surname and tei:forename">
                <xsl:value-of select="tei:forename"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="tei:surname"/>
            </xsl:when>
            <xsl:when test="tei:name">
                <xsl:value-of select="tei:name"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Afficher un auteur bibliographique -->
    <xsl:template match="tei:author" mode="bibl">
        <xsl:choose>
            <xsl:when test="tei:surname and tei:forename">
                <xsl:value-of select="tei:forename"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="tei:surname"/>
            </xsl:when>
            <xsl:when test="tei:name">
                <xsl:value-of select="tei:name"/>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="position() != last()">, </xsl:if>
    </xsl:template>

    <xsl:template match="tei:*">
        <xsl:apply-templates/>
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
