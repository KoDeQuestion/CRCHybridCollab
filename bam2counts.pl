#!/usr/bin/perl

$die = "

bam2counts.pl [bam with gene names as XS:Z: field] [output mtx]

";

if (!defined $ARGV[1]) {die $die};

open IN, "samtools view $ARGV[0] |";
while ($l = <IN>) {
	chomp $l;
	@P = split(/\t/, $l);
	$cellID = $P[0];
	$cellID =~ s/:.+$//;
	$CELLID_ct{$cellID}++;
	$gene = "Unassigned";
	for ($i = 10; $i < @P; $i++) {
		if ($P[$i] =~ /^XT:Z:/) {
			$gene = $P[$i];
			$gene =~ s/^XT:Z://;
		}
	}
	if ($gene !~ /Unassigned/i) {
		$GENE_CELLID{$gene}{$cellID}++;
	}
} close IN;

open OUT, ">$ARGV[1]";

foreach $cellID (sort keys %CELLID_ct) {
	$head .= "$cellID\t";
} $head =~ s/\t$//;

print OUT "$head\n";
foreach $gene (keys %GENE_CELLID) {
	print OUT "$gene";
	foreach $cellID (sort keys %CELLID_ct) {
		if (defined $GENE_CELLID{$gene}{$cellID}) {
			print OUT "\t$GENE_CELLID{$gene}{$cellID}";
		} else {
			print OUT "\t0";
		}
	}
	print OUT "\n";
}
