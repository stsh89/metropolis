import { Controller } from "@hotwired/stimulus"
import mermaid from "mermaid"

export default class extends Controller {
  static targets = ["input", "output"]

  async connect() {
    mermaid.initialize({ startOnLoad: false  });

    const input = this.inputTarget;
    const output = this.outputTarget;

    const drawDiagram = async function () {
      const graphDefinition = input.innerHTML;
      const { svg  } = await mermaid.render('graphDiv', graphDefinition);
      output.innerHTML = svg;
    };

    await drawDiagram();
  }
}
