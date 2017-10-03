// https://github.com/luboslenco/khatoy

import kha.*;
import kha.graphics4.*;
import kha.math.*;

class Main {
	static var pipe: PipelineState;
	static var vb: VertexBuffer;
	static var ib: IndexBuffer;
    static var iTime: ConstantLocation;
    static var iResolution: ConstantLocation;
    static var iMouse: ConstantLocation;
    static var vMouse = new FastVector4();
    static var vResolution = new FastVector2();

	static function render(framebuffer: Framebuffer): Void {
        vResolution.x = System.windowWidth();
        vResolution.y = System.windowHeight();

		var g = framebuffer.g4;
		g.begin();
		g.setPipeline(pipe);
		g.setFloat(iTime, Scheduler.time());
        g.setVector4(iMouse, vMouse);
        g.setVector2(iResolution, vResolution);
		g.setVertexBuffer(vb);
		g.setIndexBuffer(ib);
		g.drawIndexedVertices();
		g.end();
	}

	public static function main() {
		System.init({title: "Kode Project", width: 800, height: 600}, function() {

            var data = [-1.0, -1.0, 3.0, -1.0, -1.0, 3.0];
			var indices = [0, 1, 2];

			var structure = new VertexStructure();
			structure.add("pos", VertexData.Float2);

			vb = new VertexBuffer(Std.int(data.length / (structure.byteSize() / 4)), structure, Usage.StaticUsage);
			var vertices = vb.lock();
			for (i in 0...vertices.length) vertices.set(i, data[i]);
			vb.unlock();

			ib = new IndexBuffer(indices.length, Usage.StaticUsage);
			var id = ib.lock();
			for (i in 0...id.length) id[i] = indices[i];
			ib.unlock();

			pipe = new PipelineState();
			pipe.inputLayout = [structure];
			pipe.fragmentShader = Shaders.quad_frag;
			pipe.vertexShader = Shaders.quad_vert;
			pipe.compile();
            iTime = pipe.getConstantLocation("iTime");
            iMouse = pipe.getConstantLocation('iMouse');
            iResolution = pipe.getConstantLocation('iResolution');

			System.notifyOnRender(function (framebuffer) { render(framebuffer); });

            var mouse = kha.input.Mouse.get();

            if (mouse != null) {
                mouse.notify(
                    function( b, x, y ) {
						if (b == 0) {
                        	vMouse.z = 1.0;
						}
                    }, function( b, x, y ) {
                        if (b == 0) {
                            vMouse.z = 0.0;
                        }
                    }, function(x, y, dx, dy) {
                        if (vMouse.z > 0.5) {
                            vMouse.x = x;
                            vMouse.y = System.windowHeight() - y;
                        }
                    },
                    null
                );
            }
		});
	}
}