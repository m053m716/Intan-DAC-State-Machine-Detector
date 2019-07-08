//  ------------------------------------------------------------------------
//
//  This file is part of the Intan Technologies RHS2000 Interface
//  Version 1.01
//  Copyright (C) 2013-2017 Intan Technologies
//
//  ------------------------------------------------------------------------
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#ifndef SPIKEPLOT_H
#define SPIKEPLOT_H

#define SPIKEPLOT_X_SIZE 800
#define SPIKEPLOT_Y_SIZE 800
#define FSM_DIG_TRIGGER_CHANNEL 12
#define FSM_DIG_TRACKER_CHANNEL 13
#define BUFFER_SIZE 10000
#define SPIKE_WINDOW_T 3.0
#define SPIKE_WINDOW_PRE_TRIGGER 1.0
#define SPIKE_WINDOW_VLINE_1 0.5
#define SPIKE_WINDOW_VLINE_2 1.0
#define SPIKE_WINDOW_VLINE_3 2.0
#define SAMPLE_DETECTION_DELAY 2
#define PLOT_BAD_SPIKE_EVERY_N 10

#include <QWidget>
#include <QPen>

using namespace std;

class SignalProcessor;
class SpikeScopeDialog;
class SignalChannel;

class SpikePlot : public QWidget
{
    Q_OBJECT
public:
    explicit SpikePlot(SignalProcessor *inSignalProcessor, SignalChannel *initialChannel, SignalChannel *curDacChannel,
                       SpikeScopeDialog *inSpikeScopeDialog, QWidget *parent = 0, double fs = 30000.0);

    void updateWaveform(int numBlocks);
    void setMaxNumSpikeWaveforms(int num);
    void clearScope();
    void setVoltageTriggerMode(bool voltageMode);
    void setVoltageThreshold(int threshold);
    void setDigitalTriggerChannel(int channel);
    void setDigitalEdgePolarity(bool risingEdge);


    QSize minimumSizeHint() const;
    QSize sizeHint() const;

signals:
    void currentVoltageThresholdChanged(int thresh);
    void windowTypeChanged(int index);

public slots:
    void setCurrentChannel(int channel);
    void setWMax(int sample);
    void setWEnable(bool enable);
    void setWStart(int sample);
    void setWStop(int sample);
    void setWThresh(int threshold);
    void setWType(int type);
    void setWMode(bool fsmOn);

    // MM 2019-01-24
    void setSampleRate(double newSampleRate);
    void setYScale(int newYScale);
    void setNewChannel(SignalChannel* newChannel);

protected:
    void paintEvent(QPaintEvent *event);
    void closeEvent(QCloseEvent *event);
    void mousePressEvent(QMouseEvent *event);
    void wheelEvent(QWheelEvent *event);
    void keyPressEvent(QKeyEvent *event);
    void resizeEvent(QResizeEvent* event);

private:
    void initGenProperties();
    void initPenColors();
    void initDisplay();
    void initBuffers();

    void reDrawText();
    void reDrawFSMLevels();
    void reDrawAxesLines();
    void updateLevelStartStop();
    void updateSpikePlot(double rms);
    void initSpikeAxes();

    double getThresholdFromMousePress(QMouseEvent *event);
    double convertDac2Scope(double inData);

    SignalProcessor *signalProcessor;
    SpikeScopeDialog *spikeScopeDialog;

    QVector<QVector<double>> spikeWaveform;
    QVector<double> spikeWaveformBuffer;
    QVector<int> digitalInputBuffer;

    int spikeWaveformIndex;
    int numSpikeWaveforms;
    int maxNumSpikeWaveforms;
    bool voltageTriggerMode;
    int voltageThreshold;
    int digitalTriggerChannel;
    bool digitalEdgePolarity;

    // MM - UPDATE - WINDOW DISCRIMINATOR - 1/19/18
    int wMax;
    int thisChannel;
    int colorIndex;
    QVector<bool> wEnable;
    QVector<int> wStart;
    QVector<int> wStop;
    QVector<int> wType;
    QVector<int> wThresh;
    bool fsmModeOn;

    QVector<int> fsmTriggerBuffer;
    QVector<int> fsmTrackerBuffer;
    QVector<QVector<bool>> fsmColors;

    QVector<double> levelStartPoint;
    QVector<double> levelStopPoint;
    QVector<double> levelHeight;

    QPixmap pixmap;

    QPen penThisInclude;
    QPen penThisExclude;
    QPen penOtherInclude;
    QPen penOtherExclude;
    QPen penIncludeSpike;
    QPen penExcludeSpike;
    // END UPDATE

    SignalChannel *selectedChannel;
    SignalChannel *selectedDacChannel;

    QRect frame;
    QVector<QVector<QColor>> scopeColors;

    // Plotting parameters
    int rmsDisplayPeriod;
    int preTriggerTSteps;
    int totalTSteps;
    int yScale;
    double tScale;
    double tStepMsec;
    double savedRMS;

    double fsmStart;
    double frameY;
    double tAxisLength;
    double yAxisLength;

    double tScaleFactor;
    double yScaleFactor;

    double tOffset;
    double yOffset;
    double sampleRate;

    bool startingNewChannel;
    int badSpikeCounter = 0;
    int outputCounter = 0;
};

#endif // SPIKEPLOT_H
