import { JupyterFrontEnd, JupyterFrontEndPlugin } from '@jupyterlab/application';

import '../style/index.css';

/**
 * Activate extension
 */
function activate(
    app: JupyterFrontEnd,
) {
    console.log('JupyterLab extension jupyterlab-cellcodebtn is activated!');
}


/**
 * Initialization data for the jupyterlab-cellcodebtn extension.
 */
const extension: JupyterFrontEndPlugin<void> = {
    id: 'jupyterlab-cellcodebtn',
    autoStart: true,
    activate: activate
};

export default extension;
