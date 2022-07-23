INSERT INTO Renter (name, address, date_of_birth, occupation)
VALUES
    ('Genevieve Mcintyre','P.O. Box 676, 8686 Vitae, Road','2020-05-','Vestibulum Incorporated');

INSERT INTO Owned(uId)
VALUES ('78053aa0-061c-11ed-b1e1-692fb2ef982d');

INSERT INTO has
VALUES ('kjsd','393');

insert into rented
values ('j','9','neque. Nullam','2023-09','2022-06-11',1,'id,');

SELECT `COLUMN_NAME`
FROM `INFORMATION_SCHEMA`.`COLUMNS`
WHERE `TABLE_SCHEMA`='c43Project'
  AND `TABLE_NAME`='renter';

INSERT host
values (1,'Raven Baker','552-2512 Ut, Rd.','2000-02-19','Vitae Dolor Institute');

INSERT owned
values ('1','a');

DELETE FROM host
WHERE host.uId = '1';

DELETE FROM renter
WHERE renter.uId = '1';

SELECT * FROM renter WHERE renter.uId = '1';

DELETE FROM listing WHERE listing.lId IN (SELECT lId FROM owned WHERE owned.uId = '1');

CREATE TRIGGER update_rented_trigger
    BEFORE UPDATE ON rented
    FOR EACH ROW
    BEGIN
        IF NEW.end_date < CURDATE() THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'you can not cancel complete booking!';
        end if;
        UPDATE available SET available=true WHERE available.lId = NEW.lId AND available.query_date >= NEW.start_date AND available.query_date<= NEW.end_date;
    end;

UPDATE rented SET canceled=false WHERE rentedId='3_r';

DROP TRIGGER update_rented_trigger;

UPDATE rented SET canceled=true WHERE rentedId='2_r';

CREATE TRIGGER insert_listing_trigger
    AFTER INSERT ON listing
    FOR EACH ROW
BEGIN
    INSERT INTO owned VALUES (NEW.lId, '2');
end;

INSERT INTO owned VALUES ('10i', 2);

INSERT INTO listing(type,latitude,longitude,postal_code,city,country)
VALUES ('room','123','123','123','toronto','canada');

DROP TRIGGER insert_listing_trigger;

select listing.* from listing,owned where 1=1;

INSERT INTO has VALUES ('2i',(SELECT aId FROM amenities WHERE amenity='a'));

DELETE FROM has WHERE lId='2i';

UPDATE available SET price='1.1ab' WHERE true;

SELECT price*2 from available;

