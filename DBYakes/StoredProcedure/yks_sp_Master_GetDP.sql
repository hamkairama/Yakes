USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_Master_GetDP]    Script Date: 09/13/2016 19:36:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[yks_sp_Master_GetDP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[yks_sp_Master_GetDP]
GO

USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_Master_GetDP]    Script Date: 09/13/2016 19:36:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author		: Maleo Angga
-- Create date	: Jan 24, 2011
-- Description	: ambil data DP dari database

-- Enhancement yakes
-- Author		: Hamka Irama
-- Create date	: 21 September 2016
-- Description	: LEFT JOIN YKS_TRXN_WITHDRAWAL and LEFT JOIN YKS_BENEFIT
--                For history date of partial and penarikan 100% (Menu Member - Peserta) 
-- ERF          : 28-9-2016/460 
-- =============================================
CREATE PROCEDURE [dbo].[yks_sp_Master_GetDP]
	(
	@NIK varchar(10)=NULL,
	@FLAG_JENIS_FORM varchar(5),
	@KODE_DP varchar(10)=NULL
	)
	
AS
BEGIN
	IF @FLAG_JENIS_FORM = '00'
		IF @KODE_DP IS NULL
			SELECT * FROM YKS_MDP ORDER BY Kode
		ELSE 
			SELECT * FROM YKS_MDP WHERE Kode=@KODE_DP ORDER BY Kode
	ELSE IF @FLAG_JENIS_FORM = '01'
		SELECT A.PrdID,A.CompID,A.UnitID,A.MemberID,A.NIK,A.EMPName,A.EMPDate,A.EMPLevel,A.EMPStatus,A.POB,A.DOB
		,A.Sex,A.Marital,A.EmailAddr,A.PhoneNum,A.MobileNum,A.NPWPFlag,A.NPWP,A.ClientID,A.ClientDate,A.ClientStatus,A.ClientTDate,A.ClientNote
		,B.AddrType,B.Address1,B.Address2,B.Address3,B.City,B.ProvinceID,B.PostalCode,D.CardFlag,D.Formulir
		,D.PWD,D.PWDDate,D.FraudFlag,D.FraudInfo,D.FraudCase,D.RehiringFlag,D.RehiringInfo,D.RehiringNote,D.UseNewNIK,D.NIKPrev,D.RehiringDate,
		A.BankCode,A.Bank_AcNum,A.Bank_AcNm,D.FraudDate,D.FraudDateInfo,D.FraudHakBerhenti,D.FraudAmt, 
		-- Start ERF 28-9-2016/460
		CASE WHEN A.DOB IS NULL THEN 0 ELSE DATEDIFF(year, A.DOB, D.PWDDate) END AS usiaPWD,
		F.Manfaat, A.ClientTDate AS TerminateDate,
		CASE WHEN A.DOB IS NULL THEN 0 ELSE DATEDIFF(year, A.DOB, A.ClientTDate) END AS usiaCWD
		-- End ERF
		FROM YKS_MEMBER A LEFT JOIN YKS_MEMBER_ADD B ON (A.ClientID = B.ClientID) 
						  LEFT JOIN YKS_MEMBER_DETAIL D ON (A.ClientID = D.ClientID)
						-- Start ERF 28-9-2016/460
						  LEFT JOIN YKS_TRXN_WITHDRAWAL E ON (A.ClientID = E.ClientID)
						  LEFT JOIN YKS_BENEFIT F ON (A.NIK = F.NIK)
						-- End ERF
		WHERE A.NIK=@NIK
END



GO


