DROP TABLE IF EXISTS owned,renter,host,listing,available,has,amenities,rented,being_rented;

CREATE TABLE renter (
    uId char(36) primary key,
    name varchar(50) not null ,
    address varchar(225) not null,
    date_of_birth DATE not null,
    occupation varchar(225) not null,
    payment_info varchar(255) not null
);

CREATE TRIGGER renter_trigger
    BEFORE INSERT ON renter
    FOR EACH ROW
BEGIN
    IF new.uId IS NULL THEN
        SET new.uId = uuid();
    END IF;
    IF (YEAR(CURDATE()) - YEAR(new.date_of_birth)) < 18 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'need be at least 18 years old!';
    END IF;
END;

CREATE TABLE host (
                        uId char(36) primary key,
                        name varchar(50) not null ,
                        address varchar(225) not null ,
                        date_of_birth DATE not null,
                        occupation varchar(225) not null
);

CREATE TRIGGER host_trigger
    BEFORE INSERT ON host
    FOR EACH ROW
BEGIN
    IF new.uId IS NULL THEN
        SET new.uId = uuid();
    END IF;
    IF (YEAR(CURDATE()) - YEAR(new.date_of_birth)) < 18 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'need be at least 18 years old!';
    END IF;
END;

################# LISTINGS, RENTED, AVAILABLE, AMENITIES #############################################
################# LISTINGS, RENTED, AVAILABLE, AMENITIES #############################################
################# LISTINGS, RENTED, AVAILABLE, AMENITIES #############################################

CREATE TABLE listing (
                         lId char(36) NOT NULL primary key ,
                         type varchar(255) default NULL,
                         latitude double default NULL,
                         longitude  double default NULL,
                         postal_code varchar(10) default null,
                         city varchar(64) default null,
                         country varchar(32) default null
);
CREATE TRIGGER listing_trigger
    BEFORE INSERT ON listing
    FOR EACH ROW
BEGIN
    IF new.lId IS NULL THEN
        SET new.lId = uuid();
    end if;

end;
# insert into listing values(1,NULL,3,4,NULL,NULL, NULL);
# type: full house, apartment, room
CREATE TABLE available (
                           lId char(36) NOT NULL,
                           query_date date NOT NULL,
                           available boolean default FALSE,
                           price double not null default 0,
                           primary key(lId, query_date),
                           FOREIGN KEY (lId)
                            REFERENCES listing(lId)
                            ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE amenities (
                           aId char(36) NOT NULL primary key,
                           amenity varchar(255)
);

CREATE TABLE has (
                     lId char(36) NOT NULL,
                     aId char(36) NOT NULL,
                     PRIMARY KEY (lId,aId),
                     foreign key (aId) references amenities(aId),
                     foreign key (lId) references listing(lId)
);

CREATE TABLE rented (
                        lId char(36) NOT NULL,
                        rId char(36) NOT NULL,
                        comments varchar(255) default NULL,
                        start_date date NOT NULL,
                        end_date date NOT NULL,
                        rating INTEGER(5) default NULL check (rating >= 0 AND rating <= 5),
                        canceled BOOLEAN default FALSE,
                        primary key (lId, rId, start_date),
                        foreign key (lId)
                            references listing(lId)
                            ON UPDATE CASCADE ON DELETE RESTRICT,
                        foreign key (rId) references Renter(uid)
                            ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TRIGGER rented_trigger
    BEFORE INSERT ON rented
    FOR EACH ROW
BEGIN
    IF new.start_date >= new.end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'rent date invalid, start date earlier than end date';
    END IF;
END;

################# owned, being_rented #############################################
################# owned, being_rented #############################################
################# owned, being_rented #############################################

CREATE TABLE owned (
                       uId char(36) not null ,
                       lId char(36) not null ,
                       PRIMARY KEY (uId, lId),
                       FOREIGN KEY (uId)
                           REFERENCES renter(uId)
                           ON UPDATE CASCADE ON DELETE CASCADE,
                       FOREIGN KEY (lId)
                           REFERENCES listing(lId)
                           ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE being_rented (
    rId char(36) not null,
    lId char(36) not null,
    hId char(36) not null,
    start_data DATE not null,
    end_data DATE not null,
    canceled BOOLEAN default FALSE,
    rating INTEGER default null check (rating >= 0 AND rating <= 5),
    primary key (rId, lId, hId, start_data),
    FOREIGN KEY (rId)
        REFERENCES renter(uId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (hId)
        REFERENCES host(uid)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (lId)
        REFERENCES listing(lId)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TRIGGER being_rented_trigger
    BEFORE INSERT ON being_rented
    FOR EACH ROW
BEGIN
    IF new.start_data >= new.end_data THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'rent date invalid, start date earlier than end date';
    END IF;
END;