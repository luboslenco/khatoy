// https://github.com/luboslenco/khatoy
package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Image;
import kha.graphics4.*;

class Main {

	static var pipe: PipelineState;
	static var vb: VertexBuffer;
	static var ib: IndexBuffer;
    static var iTime: ConstantLocation;

	static function render(framebuffer: Framebuffer): Void {
		var g = framebuffer.g4;
		g.begin();
		g.setPipeline(pipe);
		g.setFloat(iTime, Scheduler.time());
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
			pipe.fragmentShader = kha.Shaders.quad_frag;
			pipe.vertexShader = kha.Shaders.quad_vert;
			pipe.compile();
            iTime = pipe.getConstantLocation("iTime");

			System.notifyOnRender(function (framebuffer) { render(framebuffer); });
		});
	}
}
