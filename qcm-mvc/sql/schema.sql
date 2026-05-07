-- ================================================================
-- QCM Universitaire — Schéma PostgreSQL complet
-- ================================================================

CREATE DATABASE qcm_univ ENCODING 'UTF8';
\c qcm_univ;

-- ── TABLES ──────────────────────────────────────────────────────

CREATE TABLE ETUDIANT (
    num_etudiant  VARCHAR(20)  PRIMARY KEY,
    nom           VARCHAR(100) NOT NULL,
    prenoms       VARCHAR(100) NOT NULL,
    niveau        VARCHAR(5)   NOT NULL CHECK (niveau IN ('L1','L2','L3','M1','M2')),
    adr_email     VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE LOGIN (
    code_log      SERIAL       PRIMARY KEY,
    num_etudiant  VARCHAR(20)  NOT NULL REFERENCES ETUDIANT(num_etudiant) ON DELETE CASCADE,
    mot_de_passe  VARCHAR(255) NOT NULL,
    role          VARCHAR(10)  NOT NULL DEFAULT 'etudiant' CHECK (role IN ('etudiant','admin'))
);

CREATE TABLE QCM (
    num_question  SERIAL       PRIMARY KEY,
    question      TEXT         NOT NULL,
    reponse1      VARCHAR(300) NOT NULL,
    reponse2      VARCHAR(300) NOT NULL,
    reponse3      VARCHAR(300) NOT NULL,
    reponse4      VARCHAR(300) NOT NULL,
    bonne_reponse INT          NOT NULL CHECK (bonne_reponse BETWEEN 1 AND 4),
    qcm_niveau    VARCHAR(5)   NOT NULL CHECK (qcm_niveau IN ('L1','L2','L3','M1','M2'))
);

CREATE TABLE EXAMEN (
    num_examen    SERIAL       PRIMARY KEY,
    num_etudiant  VARCHAR(20)  NOT NULL REFERENCES ETUDIANT(num_etudiant) ON DELETE CASCADE,
    anne_univ     VARCHAR(10)  NOT NULL DEFAULT '2023-2024',
    note          DECIMAL(4,2),
    statut        VARCHAR(20)  NOT NULL DEFAULT 'non_passe'
                               CHECK (statut IN ('non_passe','en_cours','termine'))
);

CREATE INDEX idx_examen_etu ON EXAMEN(num_etudiant);
CREATE INDEX idx_qcm_niveau ON QCM(qcm_niveau);

-- ── DONNÉES INITIALES ───────────────────────────────────────────

INSERT INTO ETUDIANT VALUES ('ADMIN001','Administrateur','Système','M2','admin@univ.mg');
INSERT INTO LOGIN (num_etudiant,mot_de_passe,role) VALUES ('ADMIN001','admin123','admin');

INSERT INTO ETUDIANT VALUES ('2024001','RAKOTO','Jean Paul','L2','etudiant@univ.mg');
INSERT INTO LOGIN (num_etudiant,mot_de_passe,role) VALUES ('2024001','2024001','etudiant');
INSERT INTO EXAMEN(num_etudiant,anne_univ,statut) VALUES ('2024001','2023-2024','non_passe');

INSERT INTO ETUDIANT VALUES ('2024002','RASOA','Marie','M1','rasoa@univ.mg');
INSERT INTO LOGIN (num_etudiant,mot_de_passe,role) VALUES ('2024002','2024002','etudiant');
INSERT INTO EXAMEN(num_etudiant,anne_univ,note,statut) VALUES ('2024002','2023-2024',8.5,'termine');

INSERT INTO ETUDIANT VALUES ('2024003','ANDRIANTSOA','Paul','L3','andriantsoa@univ.mg');
INSERT INTO LOGIN (num_etudiant,mot_de_passe,role) VALUES ('2024003','2024003','etudiant');
INSERT INTO EXAMEN(num_etudiant,anne_univ,note,statut) VALUES ('2024003','2023-2024',5.0,'termine');

INSERT INTO ETUDIANT VALUES ('2024004','RAHARIVELO','Soa','L1','raharivelo@univ.mg');
INSERT INTO LOGIN (num_etudiant,mot_de_passe,role) VALUES ('2024004','2024004','etudiant');
INSERT INTO EXAMEN(num_etudiant,anne_univ,note,statut) VALUES ('2024004','2023-2024',9.0,'termine');

-- ── QUESTIONS QCM ───────────────────────────────────────────────

INSERT INTO QCM(question,reponse1,reponse2,reponse3,reponse4,bonne_reponse,qcm_niveau) VALUES
-- L1 (10 questions)
('Quelle est la base du système binaire ?','Base 8','Base 10','Base 2','Base 16',3,'L1'),
('Qu''est-ce qu''un algorithme ?','Un langage de programmation','Une suite d''instructions pour résoudre un problème','Un type de données','Un ordinateur',2,'L1'),
('Complexité du tri à bulles dans le pire cas ?','O(n)','O(log n)','O(n²)','O(n log n)',3,'L1'),
('En Python, comment déclare-t-on une liste vide ?','list()','[]','Les deux sont corrects','Aucune réponse correcte',3,'L1'),
('Qu''est-ce qu''une variable ?','Un espace mémoire nommé pour stocker une valeur','Une constante','Une fonction','Un fichier',1,'L1'),
('Quelle structure fonctionne en LIFO ?','File (Queue)','Tableau','Pile (Stack)','Liste chaînée',3,'L1'),
('Résultat de 5 MOD 3 ?','1','2','0','5',2,'L1'),
('Qu''est-ce que la récursivité ?','Une boucle infinie','Une fonction qui s''appelle elle-même','Un type de tri','Une structure de données',2,'L1'),
('Porte logique retournant 1 si les deux entrées sont 1 ?','OR','NOT','AND','XOR',3,'L1'),
('Qu''est-ce que le pseudocode ?','Du code machine','Un langage naturel décrivant un algorithme','Du code Python','Un diagramme',2,'L1'),
-- L2 (10 questions)
('Qu''est-ce que l''héritage en POO ?','Copier du code','Qu''une classe hérite des attributs d''une autre','Créer un objet','Surcharger une méthode',2,'L2'),
('Mot-clé Java pour une classe abstraite ?','interface','abstract','extends','static',2,'L2'),
('Que retourne une fonction void en Java ?','Null','Rien (aucune valeur)','0','False',2,'L2'),
('Quelle couche OSI gère le routage IP ?','Couche physique','Couche liaison','Couche réseau','Couche transport',3,'L2'),
('Qu''est-ce qu''une clé étrangère en SQL ?','La clé primaire d''une table','Une colonne référençant la PK d''une autre table','Un index unique','Une contrainte CHECK',2,'L2'),
('Quel protocole envoie les emails ?','HTTP','FTP','SMTP','SSH',3,'L2'),
('Qu''est-ce que le polymorphisme ?','Même nom, comportements différents selon le contexte','Héritage multiple','Encapsulation','Une boucle',1,'L2'),
('Que fait SELECT DISTINCT en SQL ?','Sélectionne toutes les lignes','Élimine les doublons du résultat','Trie les résultats','Compte les lignes',2,'L2'),
('Qu''est-ce que l''encapsulation ?','Cacher les détails internes d''un objet','Hériter d''une classe','Créer plusieurs objets','Définir une interface',1,'L2'),
('En Java, qu''est-ce qu''une interface ?','Une classe concrète','Un contrat sans implémentation','Héritage multiple','Une exception',2,'L2'),
-- L3 (5 questions)
('Qu''est-ce que le théorème CAP ?','Cohérence Accessibilité Performance','Cohérence Disponibilité Tolérance aux partitions','Cache Atomicité Persistance','Concurrence Accès Parallélisme',2,'L3'),
('Qu''est-ce qu''une transaction ACID ?','Atomique Cohérente Isolée Durable','Asynchrone Cohérente Indépendante Durable','Atomique Concurrente Indépendante Durable','Aucune réponse correcte',1,'L3'),
('Design pattern Singleton ?','Plusieurs instances d''une classe','Une seule instance garantie','Un observateur','Une fabrique',2,'L3'),
('Différence entre TCP et UDP ?','Aucune différence','TCP fiable orienté connexion, UDP rapide sans garantie','UDP plus lent','TCP sans accusé réception',2,'L3'),
('Qu''est-ce que l''injection SQL ?','Une technique de chiffrement','Une attaque insérant du code SQL malveillant','Un ORM','Une procédure stockée',2,'L3'),
-- M1 (5 questions)
('Qu''est-ce que le ML supervisé ?','Apprentissage sans données étiquetées','Apprentissage avec données étiquetées','Apprentissage par renforcement','Deep learning uniquement',2,'M1'),
('Qu''est-ce que Docker ?','Un langage de programmation','Un outil de virtualisation légère par conteneurs','Un système de BD','Un serveur web',2,'M1'),
('Architecture microservices ?','Un monolithe optimisé','Des services indépendants via des APIs','Un pattern de BD','Un protocole réseau',2,'M1'),
('Qu''est-ce que REST ?','Un protocole de messagerie','Un style d''architecture pour les services web','Un langage de requête','Un framework Java',2,'M1'),
('Qu''est-ce que la notation Big O ?','Une notation de complexité algorithmique','Un langage','Une base de données','Un protocole',1,'M1'),
-- M2 (5 questions)
('Qu''est-ce que Kubernetes ?','Un langage de script','Un outil d''orchestration de conteneurs','Un serveur de BD','Un framework web',2,'M2'),
('Sharding en base de données ?','Un type d''index','Partitionnement horizontal des données','Un type de jointure','Une sauvegarde',2,'M2'),
('Qu''est-ce que le DevOps ?','Un langage de programmation','Une philosophie intégrant dev et opérations','Un framework','Un protocole',2,'M2'),
('Qu''est-ce que GraphQL ?','Requête pour BD relationnelles','Langage de requête pour les APIs','Un outil de visualisation','Un protocole réseau',2,'M2'),
('Qu''est-ce que le TDD ?','Tester après le développement','Écrire les tests avant le code','Un outil de déploiement','Un framework de test',2,'M2');
