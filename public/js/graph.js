function addEvent(obj, type, fn) {
    if (obj.addEventListener) obj.addEventListener(type, fn, false);
    else obj.attachEvent('on' + type, fn);
};

function init(){
    //init data
    //By defining properties with the dollar sign ($)
    //in nodes and edges we can override the global configuration
    //properties for nodes and edges.
    //In this case we use "$type" and "$dim" properties to override
    //the type of the node to be plotted and its dimension.

    var json = json_models;
    // var json = test_json;

    //end
    var infovis = document.getElementById('infovis');
    var w = infovis.offsetWidth, h = infovis.offsetHeight;
    //init canvas
    //Create a new canvas instance.
    var canvas = new Canvas('mycanvas', {
        'injectInto': 'infovis',
        'width': w,
        'height': h
    });
    //end
    //init Hypertree
    var ht = new Hypertree(canvas, {
        //By setting overridable=true,
        //Node and Edge global properties can be
        //overriden for each node/edge.
        Node: {
            overridable: true,
            'transform': false,
            color: "#f00"
        },

        Edge: {
            overridable: true,
            color: "#088"
        },

        //Change the animation transition type
        transition: Trans.Back.easeOut,
        duration:1000,

        //This method is called right before plotting an
        //edge. This method is useful for adding individual
        //styles to edges.
        onBeforePlotLine: function(adj){
            //Set random lineWidth for edges.
            if (!adj.data.$lineWidth)
                adj.data.$lineWidth = Math.random() * 5 + 1;
        },
        //Attach event handlers.
        onCreateLabel: function(domElement, node){
            domElement.innerHTML = node.name;
            domElement.style.cursor = "pointer";
            domElement.onclick = function () {
                ht.onClick(node.id, { hideLabels: false });
            };
        },

        //This method is called when moving/placing a label.
        //You can add some positioning offsets to the labels here.
        onPlaceLabel: function(domElement, node){
            var width = domElement.offsetWidth;
            var intX = parseInt(domElement.style.left);
            intX -= width / 2;
            domElement.style.left = intX + 'px';
        },

        onAfterCompute: function(){

            //Make the relations list shown in the right column.
            var node = Graph.Util.getClosestNodeToOrigin(ht.graph, "pos");
            var html = "<h4>" + node.name + "</h4><b>Connections:</b>";
            html += "<ul>";
            Graph.Util.eachAdjacency(node, function(adj){
                var child = adj.nodeTo;
                html += "<li>" + child.name + "</li>";
            });
            html += "</ul>";
            document.getElementById('inner-details').innerHTML = html;
        }
    });
    //load JSON graph.
    ht.loadJSON(json, 2);
    //compute positions and plot
    ht.refresh();
    //end
    ht.controller.onBeforeCompute(Graph.Util.getNode(ht.graph, ht.root));
    ht.controller.onAfterCompute();
}

function init_tree(){
    //init data
    //By defining properties with the dollar sign ($)
    //in nodes and edges we can override the global configuration
    //properties for nodes and edges.
    //In this case we use "$type" and "$dim" properties to override
    //the type of the node to be plotted and its dimension.

    var json = json_models;
    // var json = test_json;

    //end
    var infovis = document.getElementById('infovis');
    var w = infovis.offsetWidth, h = infovis.offsetHeight;
    //init canvas
    //Create a new canvas instance.
    var canvas = new Canvas('mycanvas', {
        'injectInto': 'infovis',
        'width': w,
        'height': h
    });
    //end
   	var style = document.getElementById('mycanvas').style;
    style.marginLeft = style.marginTop = "25px";
    //init Hypertree
    var ht = new Hypertree(canvas, {
        //Change node and edge styles such as
        //color, width and dimensions.
        Node: {
            dim: 9,
            color: "#f00"
        },

        Edge: {
            lineWidth: 2,
            color: "#088"
        },

        onBeforeCompute: function(node){
            Log.write("centering");
        },
        //Attach event handlers and add text to the
        //labels. This method is only triggered on label
        //creation
        onCreateLabel: function(domElement, node){
            domElement.innerHTML = node.name;
            addEvent(domElement, 'click', function () {
                ht.onClick(node.id);
            });
        },
        //Change node styles when labels are placed
        //or moved.
        onPlaceLabel: function(domElement, node){
            var style = domElement.style;
            style.display = '';
            style.cursor = 'pointer';
            if (node._depth <= 1) {
                style.fontSize = "0.8em";
                style.color = "#ddd";

            } else if(node._depth == 2){
                style.fontSize = "0.7em";
                style.color = "#555";

            } else {
                style.display = 'none';
            }

            var left = parseInt(style.left);
            var w = domElement.offsetWidth;
            style.left = (left - w / 2) + 'px';
        },

        onAfterCompute: function(){
            Log.write("done");

            //Build the right column relations list.
            //This is done by collecting the information (stored in the data property)
            //for all the nodes adjacent to the centered node.
            var node = Graph.Util.getClosestNodeToOrigin(ht.graph, "pos");
            var html = "<h4>" + node.name + "</h4><b>Connections:</b>";
            html += "<ul>";
            Graph.Util.eachAdjacency(node, function(adj){
                var child = adj.nodeTo;
                if (child.data) {
                    var rel = (child.data.band == node.name) ? child.data.relation : node.data.relation;
                    html += "<li>" + child.name + " " + "<div class=\"relation\">(relation: " + rel + ")</div></li>";
                }
            });
            html += "</ul>";
            document.getElementById('inner-details').innerHTML = html;
        }
    });

    //load JSON data.
    ht.loadJSON(json);
    //compute positions and plot.
    ht.refresh();
    //end
    ht.controller.onAfterCompute();
}

function init_rgraph(){
    //init data
    //By defining properties with the dollar sign ($)
    //in nodes and edges we can override the global configuration
    //properties for nodes and edges.
    //In this case we use "$type" and "$dim" properties to override
    //the type of the node to be plotted and its dimension.

    var json = json_models;
    // var json = test_json;

    //end
    var infovis = document.getElementById('infovis');
    var w = infovis.offsetWidth, h = infovis.offsetHeight;
    //init canvas
    //Create a new canvas instance.
    var canvas = new Canvas('mycanvas', {
        'injectInto': 'infovis',
        'width': w,
        'height': h,
        //Optional: Add a background canvas
        //that draws some concentric circles.
        'backgroundCanvas': {
            'styles': {
                'strokeStyle': '#444'
            },
            'impl': {
                'init': function(){},
                'plot': function(canvas, ctx){
                    var times = 6, d = 200;
                    var pi2 = Math.PI * 2;
                    for (var i = 1; i <= times; i++) {
                        ctx.beginPath();
                        ctx.arc(0, 0, i * d, 0, pi2, true);
                        ctx.stroke();
                        ctx.closePath();
                    }
                }
            }
        }
    });
    var rgraph = new RGraph(canvas, {
        //Nodes and Edges parameters
        //can be overriden if defined in
        //the JSON input data.

        //This way we can define different node
        //types individually.

        Node: {
            'overridable': true,
             'color': '#cc0000'

        },
        Edge: {
            'overridable': true,
            'color': '#cccc00'
        },

        //Set polar interpolation.
        //Default's linear.
        interpolation: 'polar',

        //Change the transition effect from linear
        //to elastic.
        transition: Trans.Elastic.easeOut,
        //Change other animation parameters.
        duration:3500,
        fps: 30,
        //Change father-child distance.
        levelDistance: 200,

        //This method is called right before plotting
        //an edge. This method is useful to change edge styles
        //individually.
        onBeforePlotLine: function(adj){
            //Add some random lineWidth to each edge.
            if (!adj.data.$lineWidth)
                adj.data.$lineWidth = Math.random() * 5 + 1;
        },

        onBeforeCompute: function(node){

            //Make right column relations list.
            var html = "<h4>" + node.name + "</h4><b>Connections:</b>";
            html += "<ul>";
            Graph.Util.eachAdjacency(node, function(adj){
                var child = adj.nodeTo;
                html += "<li>" + child.name + "</li>";
            });
            html += "</ul>";
            document.getElementById('inner-details').innerHTML = html;
        },

        //Add node click handler and some styles.
        //This method is called only once for each node/label crated.
        onCreateLabel: function(domElement, node){
            domElement.innerHTML = node.name;
            domElement.onclick = function () {
                rgraph.onClick(node.id, { hideLabels: false });
            };
            var style = domElement.style;
            style.cursor = 'pointer';
            style.fontSize = "0.8em";
            style.color = "#fff";
        },
        //This method is called when rendering/moving a label.
        //This is method is useful to make some last minute changes
        //to node labels like adding some position offset.
        onPlaceLabel: function(domElement, node){
            var style = domElement.style;
            var left = parseInt(style.left);
            var w = domElement.offsetWidth;
            style.left = (left - w / 2) + 'px';
        },

        onAfterCompute: function(){
            // Log.write("done");
        }

    });
    //load graph.
    rgraph.loadJSON(json, 1);

    //compute positions and plot
    rgraph.refresh();
    //end
    rgraph.controller.onBeforeCompute(rgraph.graph.getNode(rgraph.root));
    rgraph.controller.onAfterCompute();

}
