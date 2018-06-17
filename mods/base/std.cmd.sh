avgsum() {
	eval 'awk '\''BEGIN {min=undef;max=undef} {if(min==undef||$1<min)min=$1;if(max==undef||$1>max)max=$1;sum+=$1;count+=1} END {print min,sum/count,max,sum"/"count}'\';
}
# min avg max sum/entries
