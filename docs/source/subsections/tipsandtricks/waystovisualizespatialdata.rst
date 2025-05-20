.. raw:: html

    <script type="text/javascript">
    if (String(window.location).indexOf("readthedocs") !== -1) {
        window.alert('This example has been moved. I will redirect you to the new location.');
        window.location.replace('https://drieslab.github.io/Giotto_website/articles/visualizations.html');
    }
    </script>

.. _global-instructions-and-save-plots:

########################################################
Different Ways to Visualize Spatial Data
########################################################
This section delves into the multiple different ways that Giotto provides to visualize your spatial data.

.. tip::
	Check out the different `dataset examples <datasets>`_ to see the wide range of visualization options.

************************************************
1. Task/Analysis Specific Functions
************************************************

* **plotHeatmap**
* **plotMetadataHeatmap**
* **violinPlot**

***********************************************************************************************************
2. Functions that use the Spatial Coordinates of a Cell/Spot
***********************************************************************************************************

.. note::
	These functions generally start with spatXXX

* `spatPlot() <spatPlot>`_, to plot cell annotation information (e.g. cluster or cell type)
* `spatGenePlot() <spatGenePlot>`_, to overlay (multiple) gene expression values
* `spatCellPlot() <spatCellPlot>`_, to overlay (multiple) numerical cell values (e.g. spatial enrichment)

*******************************************************************************************************************
3. Functions that use the Dimension Reduction Coordinates of a Cell/Spot
*******************************************************************************************************************

.. note::
	These functions generally start with dimXXX


* `dimPlot() <dimPlot>`__, to plot cell annotation information (e.g. cluster or cell type)
* `dimGenePlot() <dimGenePlot>`_, to overlay (multiple) gene expression values
* `dimCellPlot() <dimCellPlot>`_, to overlay (multiple) numerical cell values (e.g. spatial enrichment)
* `plotPCA() <plotPCA>`_, `plotUMAP() <plotUMAP>`_ and `plotTSNE() <plotTSNE>`_ are shortcuts for `dimPlot() <dimPlot>`__

***********************************************************************************************************
4. Functions for co-visualization that combine spat (2) and dim (3)
***********************************************************************************************************
* spatDimPlot() <spatDimPlot>`_, to plot cell annotation information (e.g. cluster or cell type)
* `spatDimGenePlot() <spatDimGenePlot>`_, to overlay (multiple) gene expression values
* `spatDimCellPlot() <spatDimCellPlot>`_, to overlay (multiple) numerical cell values (e.g. spatial enrichment)

***********************************************************************************************************
5. Both in 2D and 3D
***********************************************************************************************************

Most functions both have a 2D and 3D version, like `spatDimPlot2D() <spatDimPlot2D>`__ and `spatDimPlot3D() <spatDimPlot3D>`__. In those cases the `spatDimPlot2D() <spatDimPlot2D>`__ is the same as `spatDimPlot() <spatDimPlot>`__.
So only in case you want to plot your spatial or dimension reduction data in 3D, you need to specifically say so.

***********************************************************************************************************
6. Ways to Save Plots
***********************************************************************************************************

.. seealso::
	Giotto Tips and Tricks: `How to visualize and save plots in Giotto? <visualize-data>`_ for more information.

All parameters available to `save_param() <save_param>`_ are found on the help page of **?Giotto::all_plots_save_function**


***************************
7. *Hypothetical Example*
***************************

.. code-block::

	# 1. standard R way
	pl = spatPlot(mygobject, cell_color = 'cell_types')
	pdf(file = 'path/to/save/to/plot.pdf')
	print(pl)
	dev.off()

	# 2. indicate to save plot, this will save the plot according to Giotto instructions file
	# If the instruction file is not provided in the beginning, it uses the defaults (e.g. working directory)
	spatPlot(mygobject, cell_color = 'cell_types', save_plot = TRUE)

	# 3. indicate to save plot and specifiy specific saving parameters by providing a list to save_param
	# they will overrule the giotto instructions
	spatPlot(mygobject, cell_color = 'cell_types', save_plot = TRUE,
         save_param = list(save_folder = 'my_subfolder', save_name = 'my_name', save_format = 'png', units = 'in'))

	# 4. don't save or return plot, but just view plot
	# defaults are: save_plot = F, return_plot = T and show_plot = T
	# this can be changed in the instructions file or at each specific plotting function
	spatPlot(mygobject, cell_color = 'cell_types', save_plot = F, return_plot = F show_plot = T)

