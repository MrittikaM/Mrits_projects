DROP TABLE IF EXISTS Campus_Eats_Audit;
CREATE TABLE Campus_Eats_Audit
(
AuditId  int NOT NULL AUTO_INCREMENT,
TableName Varchar(50),
PrimaryKey Varchar(100),
Operation ENUM ('I','U','D'),
UserId Varchar(100),
AuditTimeStamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (AuditId)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
 
 
DROP TRIGGER IF EXISTS After_person_update;
CREATE TRIGGER After_person_update
    AFTER UPDATE ON person
    FOR EACH ROW
 INSERT INTO Campus_Eats_Audit (TableName, PrimaryKey, Operation,UserId)
SELECT 'person', OLD.person_id, 'U', user();
 
DROP TRIGGER IF EXISTS After_person_insert;
CREATE TRIGGER After_person_insert
    AFTER insert ON person
    FOR EACH ROW
 INSERT INTO Campus_Eats_Audit (TableName, PrimaryKey, Operation,UserId)
SELECT 'person', NEW.person_id, 'I', user();
 
DROP TRIGGER IF EXISTS Before_person_delete;
CREATE TRIGGER Before_person_delete
    BEFORE DELETE ON person
    FOR EACH ROW
 INSERT INTO Campus_Eats_Audit (TableName, PrimaryKey, Operation,UserId)
SELECT 'person', OLD.person_id, 'D', user()