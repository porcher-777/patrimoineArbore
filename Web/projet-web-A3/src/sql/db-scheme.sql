#------------------------------------------------------------
#		Nettoyage de la base de donnée
#------------------------------------------------------------
DROP TABLE IF EXISTS arbre;
DROP TABLE IF EXISTS stadedev;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS secteur;
DROP TABLE IF EXISTS type_port;
DROP TABLE IF EXISTS type_pied;
DROP TABLE IF EXISTS espece;
DROP TABLE IF EXISTS user;

#------------------------------------------------------------
# Table: user
#------------------------------------------------------------

CREATE TABLE user(
        username Varchar (255) NOT NULL ,
        password Varchar (255) NOT NULL ,
        token    Varchar (20)
	,CONSTRAINT user_PK PRIMARY KEY (username)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: espece
#------------------------------------------------------------

CREATE TABLE espece(
        fk_espece Varchar (255) NOT NULL
	,CONSTRAINT espece_PK PRIMARY KEY (fk_espece)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: type_pied
#------------------------------------------------------------

CREATE TABLE type_pied(
        fk_pied Varchar (255) NOT NULL
	,CONSTRAINT type_pied_PK PRIMARY KEY (fk_pied)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: type_port
#------------------------------------------------------------

CREATE TABLE type_port(
        fk_port Varchar (255) NOT NULL
	,CONSTRAINT type_port_PK PRIMARY KEY (fk_port)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: secteur
#------------------------------------------------------------

CREATE TABLE secteur(
        fk_secteur Varchar (255) NOT NULL
	,CONSTRAINT secteur_PK PRIMARY KEY (fk_secteur)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: etat
#------------------------------------------------------------

CREATE TABLE etat(
        fk_etat Varchar (255) NOT NULL
	,CONSTRAINT etat_PK PRIMARY KEY (fk_etat)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: stadedev
#------------------------------------------------------------

CREATE TABLE stadedev(
        fk_stadedev Varchar (255) NOT NULL
	,CONSTRAINT stadedev_PK PRIMARY KEY (fk_stadedev)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: arbre
#------------------------------------------------------------

CREATE TABLE arbre(
        id          Int  Auto_increment  NOT NULL ,
        longitude   Decimal (18,15) NOT NULL ,
        latitude    Decimal (18,15) NOT NULL ,
        haut_tot    Decimal (4,1) NOT NULL ,
        haut_tronc  Decimal (4,1) NOT NULL ,
        tronc_diam  Int NOT NULL ,
        prec_estim  Int NOT NULL ,
        nbr_diag    Int NOT NULL ,
        remarquable Bool NOT NULL ,
        date_ajout  Datetime NOT NULL ,
        fk_espece   Varchar (255) NOT NULL ,
        fk_port     Varchar (255) NOT NULL ,
        fk_pied     Varchar (255) NOT NULL ,
        fk_secteur  Varchar (255) NOT NULL ,
        fk_etat     Varchar (255) NOT NULL ,
        fk_stadedev Varchar (255) NOT NULL ,
        username    Varchar (255) NOT NULL
	,CONSTRAINT arbre_PK PRIMARY KEY (id)

	,CONSTRAINT arbre_espece_FK FOREIGN KEY (fk_espece) REFERENCES espece(fk_espece)
	,CONSTRAINT arbre_type_port0_FK FOREIGN KEY (fk_port) REFERENCES type_port(fk_port)
	,CONSTRAINT arbre_type_pied1_FK FOREIGN KEY (fk_pied) REFERENCES type_pied(fk_pied)
	,CONSTRAINT arbre_secteur2_FK FOREIGN KEY (fk_secteur) REFERENCES secteur(fk_secteur)
	,CONSTRAINT arbre_etat3_FK FOREIGN KEY (fk_etat) REFERENCES etat(fk_etat)
	,CONSTRAINT arbre_stadedev4_FK FOREIGN KEY (fk_stadedev) REFERENCES stadedev(fk_stadedev)
	,CONSTRAINT arbre_user5_FK FOREIGN KEY (username) REFERENCES user(username)
)ENGINE=InnoDB;

