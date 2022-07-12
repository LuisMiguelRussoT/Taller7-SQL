CREATE TABLE IF NOT EXISTS type_document (
  type_doc_id INT NOT NULL,
  type_doc_name VARCHAR(4) NOT NULL,
  `delete` ENUM('true','false') DEFAULT 'false' NULL,
  PRIMARY KEY (type_doc_id))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS supplier (
  sup_id INT NOT NULL AUTO_INCREMENT,
  type_id INT NOT NULL,
  sup_number_document VARCHAR(15) NOT NULL,
  sup_name VARCHAR(45) NOT NULL,
  `delete` ENUM('true','false') DEFAULT 'false' NULL,
  PRIMARY KEY (sup_id),
  UNIQUE INDEX prov_id_UNIQUE (sup_id ASC) VISIBLE,
  UNIQUE INDEX pro_documento_UNIQUE (sup_number_document ASC, type_id ASC) VISIBLE,
  INDEX fk_supplier_type_document1_idx (type_id ASC) VISIBLE,
  CONSTRAINT fk_supplier_type_document1
    FOREIGN KEY (type_id)
    REFERENCES type_document (type_doc_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS product (
  prod_id INT NOT NULL AUTO_INCREMENT,
  supplier_sup_id INT NOT NULL,
  prod_name VARCHAR(45) NOT NULL,
  prod_price INT NOT NULL,
  `delete` ENUM('true','false') DEFAULT 'false' NULL,
  PRIMARY KEY (prod_id),
  INDEX fk_product_supplier1_idx (supplier_sup_id ASC) VISIBLE,
  CONSTRAINT fk_product_supplier1
    FOREIGN KEY (supplier_sup_id)
    REFERENCES supplier (sup_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS customer (
  cust_id INT NOT NULL AUTO_INCREMENT,
  type_id INT NOT NULL,
  cust_number_document VARCHAR(15) NOT NULL,
  `delete` ENUM('true','false') DEFAULT 'false' NULL,
  PRIMARY KEY (cust_id),
  UNIQUE INDEX cust_number_documento_UNIQUE (type_id ASC, cust_number_document ASC) VISIBLE,
  INDEX fk_customer_type_document1_idx (type_id ASC) VISIBLE,
  CONSTRAINT fk_customer_type_document1
    FOREIGN KEY (type_id)
    REFERENCES type_document (type_doc_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS invoice (
  inv_id INT NOT NULL AUTO_INCREMENT,
  customer_cust_id INT NOT NULL,
  inv_price VARCHAR(45) NOT NULL,
  `delete` ENUM('true','false') DEFAULT 'false' NULL,
  PRIMARY KEY (inv_id),
  INDEX fk_invoice_customer1_idx (customer_cust_id ASC) VISIBLE,
  CONSTRAINT fk_invoice_customer1
    FOREIGN KEY (customer_cust_id)
    REFERENCES customer (cust_id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS product_has_invoice (
  product_has_invoice_id INT NOT NULL AUTO_INCREMENT,
  product_prod_id INT NOT NULL,
  invoice_inv_id INT NOT NULL,
  product_has_invoice_quantity INT NOT NULL,
  INDEX fk_product_has_invoice_invoice1_idx (invoice_inv_id ASC) VISIBLE,
  INDEX fk_product_has_invoice_product1_idx (product_prod_id ASC) VISIBLE,
  PRIMARY KEY (product_has_invoice_id),
  CONSTRAINT fk_product_has_invoice_product1
    FOREIGN KEY (product_prod_id)
    REFERENCES product (prod_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_product_has_invoice_invoice1
    FOREIGN KEY (invoice_inv_id)
    REFERENCES invoice (inv_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

INSERT INTO type_document(type_doc_id, type_doc_name) 
VALUES (1,'CC'),
(2,'CE'),
(3,'DEL2'),
(4,'DEL1');

INSERT INTO customer(type_id, cust_number_document)
VALUES (1, '1090486380'),
(1, '123456789'),
(2, '987654321'), 
(2, '879561255'); 

INSERT INTO supplier (type_id, sup_number_document, sup_name)
VALUES (1, '74128', 'MICROSOFT'),
(1, '85239', 'SONY'),
(2, '7412589', 'NINTENDO'); 


-- -----------------------------------------------------
-- Insert data into table invoice
-- -----------------------------------------------------
INSERT INTO invoice (customer_cust_id, inv_price)
VALUES (1, '100'), 
(2, '200'), 
(3, '300'); 

-- -----------------------------------------------------
-- Insert data into product
-- -----------------------------------------------------
INSERT INTO product (supplier_sup_id, prod_name, prod_price)
VALUES (1, 'Xbox', '2400'), 
(2, 'Play', '2600'), 
(3, 'Switch', '4000'); 
-- -----------------------------------------------------
-- Insert data into table product_has_invoice
-- -----------------------------------------------------
INSERT INTO product_has_invoice (product_prod_id, invoice_inv_id, product_has_invoice_quantity)
VALUES (1,1,2),
(2,2,1),
(3,3,3);
-- -----------------------------------------------------
-- Two logical deletions of sales made.
-- -----------------------------------------------------
UPDATE product 
SET `delete` = 'true' WHERE supplier_sup_id = '1';


UPDATE product 
SET `delete` = 'true' WHERE supplier_sup_id = '2';

-- -----------------------------------------------------
-- Two physical deletions of sales made.
-- -----------------------------------------------------
DELETE
FROM invoice
WHERE inv_id = 1;

DELETE 
FROM invoice
WHERE inv_id = 2;

-- -----------------------------------------------------
-- Modify three products in your name and the supplier providing them
-- -----------------------------------------------------
UPDATE product
SET prod_name = 'Xbox One', supplier_sup_id = 1
WHERE prod_id = 1;

UPDATE product
SET prod_name = 'PlayStation 5', supplier_sup_id = 2 
WHERE prod_id = 2;

UPDATE product
SET prod_name = 'Nintendo Switch', supplier_sup_id = 3 
WHERE prod_id = 3;