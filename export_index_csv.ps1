function buscar{
	param([string]$instancia,
    [string]$user,
    [string]$pwd)
	Write-Host $instancia
    $global:teste=@"
	SET FEEDBACK OFF ECHO OFF PAGESIZE 0;
	set lines 155;
	
	SPOOL c:\index\${instancia}.csv;
    select 'Owner;Nome index;Ultima utilizacao;Tamanho MB' from dual;
	select owner || ';' ||index_name|| ';'||"Ultima_utilizacao"|| ';'|| "Tamanho_MB" from  oraadm.index_comparativo;
    spool off; 
	exit
"@
	$global:txt = $teste | sqlplus -s ${user}/${pwd}@${instancia}
}
$bancos=""
$user="teste"
$pwd="senha"
foreach ($banco in $bancos){
		buscar -instancia $banco -user $user -pwd $pwd
}