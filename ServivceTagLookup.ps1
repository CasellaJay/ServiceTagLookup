#Get-physicaldisk | Select-Object model, MediaType

#Get-WmiObject -class win32_computersystem |Format-Table name, model, @{n="ram(GB)";e={[Math]::Round($_.totalphysicalmemory/1KB/1KB/1KB)}}, @{n="MediaType"; e={Get-PhysicalDisk| Select-Object MediaType}}, @{n="total storage(GB)"; e={Get-physicaldisk | Select-Object {[Math]::Round($_.Size/ 1GB)}}}


$computers= Get-adcomputer -filter 'Name -like "DELL*"'
foreach ($computer in $computers){ 
if(Get-WmiObject -ComputerName $computer.name -Class Win32_Computersystem -ErrorAction SilentlyContinue){
    $wmio= Get-WmiObject -computername $computer.name -class Win32_Computersystem
    $Disk = get-physicaldisk -CimSession $computer.name
    $processor = get-ciminstance -computername $computer.name -class CIM_Processor
    $math= $Disk | Select-Object {[Math]::Round($_.Size/1kb/1kb/1KB)}
    $wmio | Format-Table @{n="Name";e={$computer.Name.substring(4)}}, model, @{n="ram(GB)";e={[Math]::Round($_.totalphysicalmemory/1KB/1KB/1KB)}}, @{n="DiskType"; e={$Disk | Select-Object -ExpandProperty MediaType}}, @{n="Disk Size(GB)"; e={$math}}, @{n="Processor"; e={$processor | Select-Object -ExpandProperty Name}}

}
else {
    write-host ("$computer failed")
}
}
