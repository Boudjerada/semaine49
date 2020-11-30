/*Exercice 1 ajoutez un produit dans une commande, vérifiez que le champ total est bien mis à jour*/

Drop trigger if exists `maj_total`;

DELIMITER ||

CREATE TRIGGER `maj_total` 
AFTER INSERT ON `lignedecommande`
FOR EACH ROW
BEGIN 
    DECLARE id_com INT ;
    DECLARE tot Decimal ;
    SET id_com = NEW.id_commande ;
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_com);
    UPDATE `commande` SET total=tot WHERE id=id_com ;
END ||

delimiter ;


INSERT INTO `lignedecommande` (`id_commande`, `id_produit`, `quantite`, `prix`) VALUES
(2, 5, 3, '10.00');

/* Total bien a 130 pour la commande 2 alors qu'il était à 0*/


/*Exercice 2*/

/*Ce trigger ne fonctionne que lorsque l'on ajoute des produits, les modifications ou suppressions ne permettent pas de recalculer le total. Comment pourrait-on faire ?*/

/*Modification*/
Drop trigger if exists `maj2_total`;

DELIMITER ||

CREATE TRIGGER `maj2_total`
AFTER UPDATE ON `lignedecommande`
FOR EACH ROW
BEGIN 
    DECLARE id_com INT ;
    DECLARE tot Decimal ;
    SET id_com = New.id_commande ;
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_com);
    UPDATE `commande` SET total=tot WHERE id=id_com ;
END ||

delimiter ;

/*Test*/

UPDATE `lignedecommande` SET `prix` = 15.00 where `id_produit` = 1;
/*commande 1 et 2 modifié avec succés */



/*Suppression*/
Drop trigger if exists `maj3_total`;

DELIMITER ||

CREATE TRIGGER `maj3_total` 
AFTER DELETE ON `lignedecommande`
FOR EACH ROW
BEGIN 
    DECLARE id_com INT ;
    DECLARE tot Decimal ;
    SET id_com = OLD.id_commande ;
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_com);
    UPDATE `commande` SET total=tot WHERE id=id_com ;
END ||

delimiter ;

/*Test*/
/*Suppression ligne de commande avec id produit = 5, la commande 2 est impacté */
DELETE from `lignedecommande` where `id_produit` = 5;


/*Exercice 3*/

/*Un champ remise était prévu dans la table commande. Comment pourrait-on le prendre en compte ?*/

  /*UPDATE `commande` SET `total`= total - remise WHERE id=id_com ;*/

  /*exemple en cas d'ajout */

Drop trigger if exists `maj4_total`;

DELIMITER ||

CREATE TRIGGER `maj_total4` 
AFTER INSERT ON `lignedecommande`
FOR EACH ROW
BEGIN 
    DECLARE id_com INT ;
    DECLARE tot Decimal ;
    SET id_com = NEW.id_commande ;
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_com);
    UPDATE `commande` SET total = tot - remise WHERE id=id_com ;
END ||

delimiter ;

/*exemple*/

INSERT INTO `lignedecommande` (`id_commande`, `id_produit`, `quantite`, `prix`) VALUES
(2, 4, 3, '10.00');
/*Avant la commande 2 est a 90 en total, elle passe a 110 a savoir 90 + 30 - 10 de remise*/



