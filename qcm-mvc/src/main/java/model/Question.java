package model;

import java.io.Serializable;

public class Question implements Serializable {
    private int    numQuestion;
    private String question, reponse1, reponse2, reponse3, reponse4, qcmNiveau;
    private int    bonneReponse;   // 1-4
    private int    reponseDonnee;  // 0 = non répondu

    public int    getNumQuestion()        { return numQuestion; }
    public void   setNumQuestion(int v)   { numQuestion = v; }
    public String getQuestion()           { return question; }
    public void   setQuestion(String v)   { question = v; }
    public String getReponse1()           { return reponse1; }
    public void   setReponse1(String v)   { reponse1 = v; }
    public String getReponse2()           { return reponse2; }
    public void   setReponse2(String v)   { reponse2 = v; }
    public String getReponse3()           { return reponse3; }
    public void   setReponse3(String v)   { reponse3 = v; }
    public String getReponse4()           { return reponse4; }
    public void   setReponse4(String v)   { reponse4 = v; }
    public int    getBonneReponse()       { return bonneReponse; }
    public void   setBonneReponse(int v)  { bonneReponse = v; }
    public String getQcmNiveau()          { return qcmNiveau; }
    public void   setQcmNiveau(String v)  { qcmNiveau = v; }
    public int    getReponseDonnee()      { return reponseDonnee; }
    public void   setReponseDonnee(int v) { reponseDonnee = v; }

    public String getOption(int i) {
        return switch(i) { case 1->reponse1; case 2->reponse2; case 3->reponse3; case 4->reponse4; default->""; };
    }
    public boolean isCorrect() { return reponseDonnee == bonneReponse; }
}
