import {
    JupyterFrontEnd,
    JupyterFrontEndPlugin,
} from '@jupyterlab/application';

import {
    INotebookTracker,
    NotebookPanel,
} from '@jupyterlab/notebook';

import {
    CodeCell,
} from '@jupyterlab/cells';

import {
    ReadonlyJSONObject,
} from '@phosphor/coreutils';

import '../style/index.css';


class CellFooterButton {

    constructor(app: JupyterFrontEnd, tracker: INotebookTracker) {
        this.tracker = tracker;
        this.app = app;
        this.tracker.widgetAdded.connect(this.onWidgetAdded, this);
        this.onActiveCellChanged();
        this.tracker.activeCellChanged.connect(this.onActiveCellChanged, this);
    }

    private tracker: INotebookTracker;
    private app: JupyterFrontEnd;

    // update cells type
    private onWidgetAdded(sender: any, widget: any): void {
        let notebook = widget.content;
        console.log('widget added', notebook);
    }

    private onActiveCellChanged(): void {
        let activeCell = this.tracker.activeCell;
        if (activeCell !== null) {
            const {commands} = this.app;

            if (activeCell.model.type === 'code') {
                console.log('code cell')
                let codecell = activeCell as CodeCell;
                this.createCellFooter(codecell);
            } else {
                console.log("something else");
            }
        }
    }

    private createCellFooter(cell: CodeCell): void {
        let cellFooterDiv = cell.node.getElementsByClassName('ccb-cellFooterContainer')[0];
        console.log('and it is', cellFooterDiv);
        if (cellFooterDiv !== undefined) {
            return;
        }
        cellFooterDiv = document.createElement('div');
        cellFooterDiv.className = 'ccb-cellFooterContainer';
        // cellFooterDiv.innerHTML = '<button class="ccb-cellFooterBtn">Run</button>';
        let cellFooterButton =  document.createElement('button');
        cellFooterButton.className = 'ccb-cellFooterBtn';
        cellFooterButton.innerHTML = 'run';
        cellFooterButton.addEventListener('click', (event) => {
            console.log('clicked', cell);
        });

        let cellFooter = cell.node.getElementsByClassName('jp-CellFooter')[0];
        cellFooterDiv.appendChild(cellFooterButton);
        cellFooter.appendChild(cellFooterDiv);
    }
}


function activate(app: JupyterFrontEnd, tracker: INotebookTracker): Promise<void> {
    console.log('JupyterLab extension jupyterlab-cellcodebtn is activated!');

    Promise.all([app.restored]).then(([args]) => {
        const { commands, shell } = app;
        function getCurrent(args: ReadonlyJSONObject): NotebookPanel | null {
            const widget = tracker.currentWidget;
            const activate = args['activate'] !== false;

            if (activate && widget) {
                shell.activateById(widget.id);
            }

            return widget;
        }
        function isEnabled(): boolean {
            return tracker.currentWidget !== null &&
                tracker.currentWidget === app.shell.currentWidget;
        }

        // tslint:disable:no-unused-expression
        new CellFooterButton(app, tracker);
    });

    return Promise.resolve();
}


const extension: JupyterFrontEndPlugin<void> = {
    id: 'jupyterlab-cellcodebtn',
    autoStart: true,
    activate: activate,
    requires: [INotebookTracker]
};

export default extension;
