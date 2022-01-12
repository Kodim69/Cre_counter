#

print "Add Yandex.Metrika counter into *.htm \n" if !$ARGV[0];
print "Usage: $0 <*.htm> \n" if !$ARGV[0];


my $yan_cnt=qq(
<!-- Yandex.Metrika informer -->
<a href="https://metrika.yandex.ru/stat/?id=86713824&amp;from=informer"
target="_blank" rel="nofollow"><img src="https://informer.yandex.ru/informer/86713824/3_1_FFFFFFFF_EFEFEFFF_0_pageviews"
style="width:88px; height:31px; border:0;" alt="Яндекс.Метрика" title="Яндекс.Метрика: данные за сегодня (просмотры, визиты и уникальные посетители)" class="ym-advanced-informer" data-cid="86713824" data-lang="ru" /></a>
<!-- /Yandex.Metrika informer -->

<!-- Yandex.Metrika counter -->
<script type="text/javascript" >
   (function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
   m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
   (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

   ym(86713824, "init", {
        clickmap:true,
        trackLinks:true,
        accurateTrackBounce:true
   });
</script>
<noscript><div><img src="https://mc.yandex.ru/watch/86713824" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
<!-- /Yandex.Metrika counter -->
);

my $yan_cnt_exist=0;

my @fileNames=glob($ARGV[1]);

if (!$fileNames[0]) {print "No files $ARGV[1] for processing. \n"; exit;} 
	else {print "Files: @fileNames \n"; }


for(my $file_name_in=shift @fileNames)
{

	print "Processing... $file_name_in...";
	open my $file_in,  '<', $file_name_in or warn "Cannot open file $file_name_in: $!" and next;
        
	my $file_name_out=$file_name_in.'.tmp';
	open my $file_out, '>', $file_name_out or warn "Cannot open file $file_name_out: $!" and next;
        
	while(my $s=<$file_in>)
	{
		$yan_cnt_exists=1 if $s=~/Metrika/;
		print $file_out $yan_cnt if $s=~/\/body/ and !$yan_cnt_exist;
		print $file_out $s;
	}
	close $file_in or warn "Cannot close $file_in" and next;
	close $file_out or warn "Cannot close $file_out" and next;

	print "Done.\n";
	rename("$file_name_in","$file_name_in".".bak") or warn "Can't rename $file_name_in: $!" and next;	
	rename("$file_name_out","$file_name_in") or warn "Can't rename $file_name_out: $!" and next;	
	
}

exit;
 
