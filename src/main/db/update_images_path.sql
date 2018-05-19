/*
* Moving all images to 'images' folder (removed other_images, otherimages folder)
*/

update t_master_productsaleinfo set Product_Image_File = replace(Product_Image_File, '/Product_Images/', '/images/')

update t_master_supplierinfo set Supplier_Image = replace(Supplier_Image, '/Product_Images/', '/images/')

