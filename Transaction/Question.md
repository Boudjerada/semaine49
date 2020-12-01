
TRANSACTION

START TRANSACTION;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120;    
UPDATE fournis SET nomfou = 'GROSBRIGAND' WHERE fournis_numfou = 120;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120; 
L'instruction START TRANSACTION est suivie d'une instruction UPDATE, mais aucune instruction COMMIT ou ROLLBACK correspondante n'est présente.
Que concluez-vous ?
La transaction s'est effectué sans erreur, elle attend une validation via un commit car pour le moment aucune donnés n'est modifié physiquement dans la base. Le nom du fournisseur 120 est inchangé dans la base Papyrus.
select nomfou from fournis WHERE fournis_numfou = 120;  => GROBRIGAND
Les données sont-elles modifiables par d'autres utilisateurs (ouvrez une nouvelle fenêtre de requête pour interroger le fournisseur 120 par une instruction SELECT)
drop role if exists 'administrateurpapyrus'@'%';
CREATE ROLE 'administrateurpapyrus'@'%';
GRANT ALL ON papyrus.* TO 'administrateurpapyrus'@'%';
drop user if exists 'test1'@'%';
CREATE USER if not exists 'test1'@'%' IDENTIFIED BY 'test1';
GRANT  'administrateurpapyrus'@'%' TO 'test1'@'%';
SET DEFAULT ROLE 'administrateurpapyrus'@'%' TO 'test1'@'%';

L'utilisateur visit1 à lecture sur données avant transaction effectué par root. Il peut lire et modifié. 
select nomfou from fournis WHERE fournis_numfou = 120;  
=> GROBRIGAND
UPDATE fournis SET nomfou = 'GROSSSBRIGAND' WHERE fournis_numfou = 120; 
=> il y'a modification, le nom du fournisseur 120 devient 'GROSSSBRIGAND' 
La transaction est-elle terminée ?
Oui mais elle n'a pas d'incidence sur la base papyrus car on ne l'a pas validé.
Comment rendre la modification permanente ?
Avec un commit qui suis la transaction.
START TRANSACTION;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120;    
UPDATE fournis SET nomfou = 'GROSBRIGAND' WHERE fournis_numfou = 120;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120; 
commit;

select nomfou from fournis WHERE fournis_numfou = 120;  => GROSBRIGAND
Comment annuler la transaction ?
Aprés un commit, il n'est plus possible d'annuler une transaction. 
Le rollback sert lorsque nous sommes pas en innodb, apres la transaction il évite le commit par defaut du non innodb.



