package util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    private static final String HOST  = "smtp.gmail.com";
    private static final String PORT  = "587";
    private static final String FROM  = "qcm.univ.mg@gmail.com";
    private static final String PASS  = "votre_app_password_gmail";

    public static void envoyerResultat(String to, String nom, String niveau, double note, String annee) {
        Properties p=new Properties();
        p.put("mail.smtp.auth","true"); p.put("mail.smtp.starttls.enable","true");
        p.put("mail.smtp.host",HOST);   p.put("mail.smtp.port",PORT);
        Session s=Session.getInstance(p,new Authenticator(){
            protected PasswordAuthentication getPasswordAuthentication(){ return new PasswordAuthentication(FROM,PASS); }
        });
        try {
            String mention=note>=9?"Excellent":note>=8?"Très Bien":note>=7?"Bien":note>=5?"Passable":"Insuffisant";
            Message m=new MimeMessage(s);
            m.setFrom(new InternetAddress(FROM,"QCM Universitaire"));
            m.setRecipients(Message.RecipientType.TO,InternetAddress.parse(to));
            m.setSubject("Résultat examen QCM — "+annee);
            m.setText("""
                Bonjour %s,

                Votre examen QCM pour l'année %s a été soumis.

                  Niveau  : %s
                  Note    : %.1f / 10
                  Mention : %s

                Résultat transmis à votre enseignant.

                Cordialement,
                Département Informatique
                """.formatted(nom,annee,niveau,note,mention));
            Transport.send(m);
        } catch(Exception e){ System.err.println("[Email] "+e.getMessage()); }
    }
}
