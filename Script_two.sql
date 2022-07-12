SELECT type_document.type_doc_name as 'Tipo de documento', 
customer.cust_number_document as 'Número de Documento', product.prod_name as 'Producto' 
FROM product 
JOIN product_has_invoice ON product_has_invoice.product_has_invoice_id = product.prod_id 
JOIN invoice ON invoice.inv_id = product_has_invoice.invoice_inv_id
JOIN customer ON customer.cust_id = invoice.customer_cust_id
JOIN type_document ON type_document.type_doc_id = customer.type_id
WHERE type_id = 1
AND cust_number_document = '1090486380';


SELECT prod_name as 'Producto', sup_name as 'Proveedor' 
FROM supplier 
JOIN product ON product.supplier_sup_id = supplier.sup_id
WHERE prod_name = 'Club Colombia Roja Lata 330ml';

 