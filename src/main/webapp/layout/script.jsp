<%@include file="taglib.jsp" %>
<script>var path = '${path}';</script>
<script src="<c:url value="/assets/js/jquery.js" />"></script>
<script src="<c:url value="/assets/js/bootstrap3.js" />"></script>
<script src="<c:url value="/assets/js/prettify.js" />"></script>
<script src="<c:url value="/assets/js/lang-sql.js" />"></script>
<script src="<c:url value="/assets/js/lang-css.js" />"></script>
<script src="<c:url value="/assets/js/coeus.sparql.js" />"></script>
<script src="<c:url value="/assets/js/coeus.setup.js" />"></script>
<script src="<c:url value="/assets/js/bootstrap-tooltip.js" />"></script>
<script type="text/javascript">
    //code called on every page
    $(document).ready(function() {
        loadSeedsOnSidebar();
    });
</script>
<script type="text/javascript">
    var $buoop = {vs: {i: 8, f: 4, o: 11, s: 5, n: 9}}
    $buoop.ol = window.onload;
    window.onload = function() {
        try {
            if ($buoop.ol)
                $buoop.ol();
        } catch (e) {
        }
        var e = document.createElement("script");
        e.setAttribute("type", "text/javascript");
        e.setAttribute("src", "http://browser-update.org/update.js");
        document.body.appendChild(e);
    }
</script>
 <script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-12230872-7']);
    _gaq.push(['_trackPageview']);
    (function() {
        var ga = document.createElement('script');
        ga.type = 'text/javascript';
        ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ga, s);
    })();
</script>
<script src="<c:url value="/assets/js/coeus.powered.js" />"></script>