package model;

import java.io.Serializable;

public class Etudiant implements Serializable {
    private String numEtudiant, nom, prenoms, niveau, adrEmail, role;

    public Etudiant() {}
    public Etudiant(String numEtudiant, String nom, String prenoms,
                    String niveau, String adrEmail, String role) {
        this.numEtudiant = numEtudiant; this.nom = nom; this.prenoms = prenoms;
        this.niveau = niveau; this.adrEmail = adrEmail; this.role = role;
    }

    public String getNumEtudiant()          { return numEtudiant; }
    public void   setNumEtudiant(String v)  { numEtudiant = v; }
    public String getNom()                  { return nom; }
    public void   setNom(String v)          { nom = v; }
    public String getPrenoms()              { return prenoms; }
    public void   setPrenoms(String v)      { prenoms = v; }
    public String getNiveau()               { return niveau; }
    public void   setNiveau(String v)       { niveau = v; }
    public String getAdrEmail()             { return adrEmail; }
    public void   setAdrEmail(String v)     { adrEmail = v; }
    public String getRole()                 { return role; }
    public void   setRole(String v)         { role = v; }

    public String getNomComplet()  { return prenoms + " " + nom; }
    public String getInitiales() {
        String n = (nom    != null && !nom.isEmpty())    ? nom.substring(0,1).toUpperCase()    : "";
        String p = (prenoms!= null && !prenoms.isEmpty())? prenoms.substring(0,1).toUpperCase(): "";
        return n + p;
    }
}
