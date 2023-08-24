import { Controller } from "@hotwired/stimulus"
import mermaid from "mermaid"

export default class extends Controller {
  static targets = ["input", "output"]

  async connect() {
    mermaid.initialize({ startOnLoad: false  });

    await this.drawDiagram();
  }

  async drawDiagram() {
    const input = this.inputTarget;
    const output = this.outputTarget;
    const graphDefinition = input.value;
    const { svg  } = await mermaid.render('graphDiv', graphDefinition);
    output.innerHTML = svg;
  }
}
