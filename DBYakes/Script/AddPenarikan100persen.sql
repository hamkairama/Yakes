-- Enhancement Yakes
-- Author      : Hamka Irama
-- Date        : 21 Sept 2016
-- Description : adding Jenis Manfaat "Penarikan 100%" on dropdown Jenis Manfaat in menu Hitung Benefit

 if not exists (select * from YKS_MASTER_FIELD_VALUES where GRP_NM = 'HITUNG_MANFAAT' and FLD_VALUE_DESC = 'Penarikan 100%')
	insert into YKS_MASTER_FIELD_VALUES values ('HITUNG_MANFAAT', '04', 'Penarikan 100%', 'Penarikan 100%', 4, null, null, null)
  else
	print 'data already exist'