package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Examen implements Serializable {
    private int numExamen;
    private String numEtudiant, anneUniv, statut;
    private BigDecimal note;

    public int        getNumExamen()        { return numExamen; }
    public void       setNumExamen(int v)   { numExamen = v; }
    public String     getNumEtudiant()      { return numEtudiant; }
    public void       setNumEtudiant(String v){ numEtudiant = v; }
    public String     getAnneUniv()         { return anneUniv; }
    public void       setAnneUniv(String v) { anneUniv = v; }
    public String     getStatut()           { return statut; }
    public void       setStatut(String v)   { statut = v; }
    public BigDecimal getNote()             { return note; }
    public void       setNote(BigDecimal v) { note = v; }

    public boolean isTermine()  { return "termine".equals(statut); }
    public boolean isEnCours()  { return "en_cours".equals(statut); }
    public boolean isNonPasse() { return "non_passe".equals(statut); }

    public String getMention() {
        if (note == null) return "";
        double n = note.doubleValue();
        if (n >= 9) return "Excellent";
        if (n >= 8) return "Très Bien";
        if (n >= 7) return "Bien";
        if (n >= 5) return "Passable";
        return "Insuffisant";
    }
}
