USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_ReportPesertaFull]    Script Date: 09/09/2016 20:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[yks_sp_ReportPesertaFull]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[yks_sp_ReportPesertaFull]
GO

USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_ReportPesertaFull]    Script Date: 09/09/2016 20:52:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Enhancement yakes
-- Author		: Hamka Irama
-- Create date	: Agustus ,  2016
-- Description	: report peserta penarikan 100%
-- ERF          : 28-9-2016/460 
-- =============================================
CREATE PROCEDURE [dbo].[yks_sp_ReportPesertaFull]
	(
	@Period	varchar(6)
	)
AS
BEGIN
	select C.NIK as AgentCode, C.EMPName as AgentName, B.TerminateDate as TanggalPenarikan, C.EMPLevel
	from YKS_PAYMENT_BEN A
		inner join YKS_BENEFIT B on B.BenefitID = A.BenefitID
		inner join YKS_MEMBER C on C.NIK = B.NIK
	where 
	--A.Periode = @Period --reques ibu ayu. all retrieve without periode
	B.Manfaat = 'Penarikan 100%'
	order by B.TerminateDate asc
END




GO


