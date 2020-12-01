
TRANSACTION

START TRANSACTION;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120;    
UPDATE fournis SET nomfou = 'GROSBRIGAND' WHERE fournis_numfou = 120;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120; 
L'instruction START TRANSACTION est suivie d'une instruction UPDATE, mais aucune instruction COMMIT ou ROLLBACK correspondante n'est pr�sente.
Que concluez-vous ?
La transaction s'est effectu� sans erreur, elle attend une validation via un commit car pour le moment aucune donn�s n'est modifi� physiquement dans la base. Le nom du fournisseur 120 est inchang� dans la base Papyrus.
select nomfou from fournis WHERE fournis_numfou = 120;  => GROBRIGAND
Les donn�es sont-elles modifiables par d'autres utilisateurs (ouvrez une nouvelle fen�tre de requ�te pour interroger le fournisseur 120 par une instruction SELECT)
drop role if exists 'administrateurpapyrus'@'%';
CREATE ROLE 'administrateurpapyrus'@'%';
GRANT ALL ON papyrus.* TO 'administrateurpapyrus'@'%';
drop user if exists 'test1'@'%';
CREATE USER if not exists 'test1'@'%' IDENTIFIED BY 'test1';
GRANT  'administrateurpapyrus'@'%' TO 'test1'@'%';
SET DEFAULT ROLE 'administrateurpapyrus'@'%' TO 'test1'@'%';

L'utilisateur visit1 � lecture sur donn�es avant transaction effectu� par root. Il peut lire et modifi�. 
select nomfou from fournis WHERE fournis_numfou = 120;  
=> GROBRIGAND
UPDATE fournis SET nomfou = 'GROSSSBRIGAND' WHERE fournis_numfou = 120; 
=> il y'a modification, le nom du fournisseur 120 devient 'GROSSSBRIGAND' 
La transaction est-elle termin�e ?
Oui mais elle n'a pas d'incidence sur la base papyrus car on ne l'a pas valid�.
Comment rendre la modification permanente ?
Avec un commit qui suis la transaction.
START TRANSACTION;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120;    
UPDATE fournis SET nomfou = 'GROSBRIGAND' WHERE fournis_numfou = 120;
SELECT nomfou FROM fournis WHERE fournis_numfou = 120; 
commit;

select nomfou from fournis WHERE fournis_numfou = 120;  => GROSBRIGAND
Comment annuler la transaction ?
Apr�s un commit, il n'est plus possible d'annuler une transaction. 
Le rollback sert lorsque nous sommes pas en innodb, apres la transaction il �vite le commit par defaut du non innodb.



